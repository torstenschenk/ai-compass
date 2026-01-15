import psycopg2
from psycopg2 import extras
from dotenv import load_dotenv
import os
import pandas as pd
import numpy as np
import re

# Load environment variables
load_dotenv()

# Database connection
def get_db_connection():
    return psycopg2.connect(
        user=os.getenv("user"),
        password=os.getenv("password"),
        host=os.getenv("host"),
        port=os.getenv("port"),
        dbname=os.getenv("dbname")
    )

def fetch_questions_and_answers():
    """Fetch all questions and answers from database."""
    conn = get_db_connection()
    cur = conn.cursor(cursor_factory=extras.RealDictCursor)
    
    # Fetch questions ordered by question_id
    cur.execute("SELECT * FROM questions ORDER BY question_id;")
    questions = cur.fetchall()
    
    # Fetch answers
    cur.execute("SELECT * FROM answers ORDER BY question_id, answer_id;")
    answers = cur.fetchall()
    
    cur.close()
    conn.close()
    
    return questions, answers

def create_answer_map(answers):
    """Create answer mapping by question_id."""
    from collections import defaultdict
    answer_map = defaultdict(dict)
    for ans in answers:
        qid = ans['question_id']
        answer_map[qid][ans['answer_text']] = ans
    return answer_map

def normalize_text_for_comparison(text):
    """
    Robust normalization:
    1. Convert to string
    2. Lowercase
    3. Remove ALL non-alphanumeric characters (keep only a-z, 0-9)
    This handles all dash variations, smart quotes, extra spaces, etc.
    """
    if pd.isna(text):
        return ""
    
    text = str(text).lower()
    # keep only alphanumeric
    clean_text = re.sub(r'[^a-z0-9]', '', text)
    return clean_text

def smart_match_answers(answer_text_csv, answer_map_for_question, question_type):
    """
    Intelligently match CSV answer text to database answers.
    Uses robust normalization to handle character mismatches.
    """
    if pd.isna(answer_text_csv):
        return []
        
    answer_text_csv_str = str(answer_text_csv).strip()
    
    # 1. OPTIMIZATION: Try exact match first
    if answer_text_csv_str in answer_map_for_question:
        return [answer_map_for_question[answer_text_csv_str]]
    
    # 2. Normalized match (strip non-alphanumeric)
    normalized_csv = normalize_text_for_comparison(answer_text_csv_str)
    
    # Pre-calculate normalized DB answers
    # (In production, do this once outside the loop, but here it's fine for 500 rows)
    db_answers_normalized = {}
    for text, obj in answer_map_for_question.items():
        db_answers_normalized[normalize_text_for_comparison(text)] = obj
        
    if normalized_csv in db_answers_normalized:
        return [db_answers_normalized[normalized_csv]]
    
    # 3. For checklist questions, handle multiple selections
    if question_type == 'Checklist':
        # Strategy: Match largest chunks from normalized string
        matched_answers = []
        remaining_norm = normalized_csv
        
        # Sort keys by length descending to match longest first
        sorted_keys = sorted(db_answers_normalized.keys(), key=len, reverse=True)
        
        max_iterations = 20
        iteration = 0
        
        while remaining_norm and iteration < max_iterations:
            iteration += 1
            found_match = False
            
            for key in sorted_keys:
                if key in remaining_norm:
                    matched_answers.append(db_answers_normalized[key])
                    # Remove the matched part from remaining string
                    # Note: this is a simple replace, might be risky if substrings repeat
                    # but typically checklist answers are distinct enough.
                    remaining_norm = remaining_norm.replace(key, '', 1)
                    found_match = True
                    break
            
            if not found_match:
                break
                
        if matched_answers:
            return matched_answers

    return []

def process_csv_data_v4(csv_path, questions, answer_map):
    """Process CSV using POSITIONAL matching and NORMALIZED text matching."""
    print(f"Loading CSV from {csv_path}...")
    df = pd.read_csv(csv_path)
    
    print(f"Loaded {len(df)} rows")
    
    # Get question columns (H onwards, index 7+)
    question_cols = df.columns[7:].tolist()
    
    company_ids = df.iloc[:, 0].values
    
    # Output structure
    answer_id_data = {'company_id': company_ids}
    total_scores = []
    
    # Stats
    unmapped_answers_count = 0
    total_answers_processed = 0
    
    print("\nProcessing each company...")
    
    for idx, row in df.iterrows():
        if idx % 100 == 0:
            print(f"  Processing row {idx}/{len(df)}")
        
        company_score = 0.0
        
        for col_idx, csv_column_name in enumerate(question_cols):
            # Positional match
            if col_idx >= len(questions):
                continue
            
            question_obj = questions[col_idx]
            question_id = question_obj['question_id']
            question_type = question_obj['type']
            question_weight = question_obj['weight']
            
            answer_text = row.iloc[7 + col_idx]
            
            if pd.isna(answer_text):
                continue
            
            total_answers_processed += 1
            
            # Use improved matching
            matched_answer_objs = smart_match_answers(answer_text, answer_map[question_id], question_type)
            
            if not matched_answer_objs:
                unmapped_answers_count += 1
                # Optional: print first few failures
                if unmapped_answers_count <= 5:
                    print(f"  Failed to match: Q{question_id} - '{str(answer_text)[:50]}...'")
                continue
            
            # Extract IDs and Scores
            answer_ids = [ans['answer_id'] for ans in matched_answer_objs]
            answer_weights_sum = sum(ans['answer_weight'] for ans in matched_answer_objs)
            
            # Store IDs
            col_name = f"q{question_id}_answer_id"
            if col_name not in answer_id_data:
                answer_id_data[col_name] = [None] * len(df)
            
            answer_id_data[col_name][idx] = ','.join(map(str, answer_ids))
            
            # Calc Score
            if question_type == 'Checklist':
                capped_sum = min(answer_weights_sum, 100)
                scaled_value = (capped_sum / 100) * 4 + 1
                question_score = (scaled_value * question_weight) / 100
            else:
                question_score = (answer_weights_sum * question_weight) / 100
            
            company_score += question_score
        
        total_scores.append(company_score)
    
    # Create DataFrames
    df_answer_ids = pd.DataFrame(answer_id_data)
    df_scores = pd.DataFrame({
        'company_id': company_ids,
        'total_score': total_scores
    })
    
    print("\n" + "="*80)
    print("PROCESSING REPORT (V4)")
    print("="*80)
    print(f"Total answers processed: {total_answers_processed}")
    print(f"Unmapped answers: {unmapped_answers_count} ({unmapped_answers_count/total_answers_processed*100:.2f}%)")
    print(f"Output columns: {len(df_answer_ids.columns)}")
    
    return df_answer_ids, df_scores

def main():
    print("="*80)
    print("ASSESSMENT DATA PROCESSING V4 (ROBUST NORMALIZATION)")
    print("="*80)
    
    print("\n1. Fetching DB data...")
    questions, answers = fetch_questions_and_answers()
    
    print("\n2. Creating mappings...")
    answer_map = create_answer_map(answers)
    
    print("\n3. Processing CSV...")
    csv_path = 'AI_Compass_data_generation_2/assessment_data.csv'
    df_answer_ids, df_scores = process_csv_data_v4(csv_path, questions, answer_map)
    
    print("\n4. Saving V4 output files...")
    output_file_1 = 'DB_Tables_Raw/assessment_processing/company_answers_with_ids_v4.csv'
    output_file_2 = 'DB_Tables_Raw/assessment_processing/company_total_scores_v4.csv'
    
    df_answer_ids.to_csv(output_file_1, index=False)
    print(f"   Saved: {output_file_1}")
    df_scores.to_csv(output_file_2, index=False)
    print(f"   Saved: {output_file_2}")
    
if __name__ == "__main__":
    main()
