import psycopg2
from psycopg2 import extras
from dotenv import load_dotenv
import os
import pandas as pd
import numpy as np

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

def smart_match_answers(answer_text_csv, answer_map_for_question, question_type):
    """
    Intelligently match CSV answer text to database answers.
    For checklist questions, handles comma-separated answers where answer text itself contains commas.
    """
    answer_text_csv = str(answer_text_csv).strip()
    
    # First, try exact match (single answer)
    if answer_text_csv in answer_map_for_question:
        return [answer_map_for_question[answer_text_csv]]
    
    # For checklist questions, try to parse multiple answers
    if question_type == 'Checklist':
        # Strategy: Try to match against all possible answers from longest to shortest
        matched_answers = []
        remaining_text = answer_text_csv
        
        # Sort answers by length (longest first) to match longer texts first
        sorted_answers = sorted(answer_map_for_question.items(), key=lambda x: len(x[0]), reverse=True)
        
        # Keep trying to find matches until no more text remains
        max_iterations = 20
        iteration = 0
        
        while remaining_text.strip() and iteration < max_iterations:
            iteration += 1
            found_match = False
            
            for ans_text, ans_obj in sorted_answers:
                if ans_text in remaining_text:
                    matched_answers.append(ans_obj)
                    remaining_text = remaining_text.replace(ans_text, '', 1)
                    remaining_text = remaining_text.strip(', ')
                    found_match = True
                    break
            
            if not found_match:
                break
        
        if matched_answers:
            return matched_answers
    
    return []

def process_csv_data_positional(csv_path, questions, answer_map):
    """Process CSV using POSITIONAL matching - question columns map to question_ids by index."""
    print(f"Loading CSV from {csv_path}...")
    df = pd.read_csv(csv_path)
    
    print(f"Loaded {len(df)} rows")
    
    # Get question columns (H onwards, index 7+)
    question_cols = df.columns[7:].tolist()
    
    print(f"Found {len(question_cols)} question columns in CSV")
    print(f"Database has {len(questions)} questions")
    
    if len(question_cols) != len(questions):
        print(f"WARNING: Column count mismatch! CSV has {len(question_cols)}, DB has {len(questions)}")
    
    # Prepare output dataframes
    company_ids = df.iloc[:, 0].values
    
    # For CSV 1: company_id + answer_ids for each question
    answer_id_data = {'company_id': company_ids}
    
    # For CSV 2: company_id + total_score
    total_scores = []
    
    # Track statistics
    unmapped_answers_count = 0
    total_answers_processed = 0
    
    print("\nProcessing each company...")
    
    for idx, row in df.iterrows():
        if idx % 100 == 0:
            print(f"  Processing row {idx}/{len(df)}")
        
        company_score = 0.0
        
        # Process each question column by POSITION
        for col_idx, csv_column_name in enumerate(question_cols):
            # Map by position: column index -> question object
            if col_idx >= len(questions):
                print(f"  Warning: Column {col_idx} exceeds question count, skipping")
                continue
            
            question_obj = questions[col_idx]
            question_id = question_obj['question_id']
            question_type = question_obj['type']
            question_weight = question_obj['weight']
            
            # Get answer text from CSV
            answer_text = row.iloc[7 + col_idx]
            
            # Handle NaN/missing values
            if pd.isna(answer_text):
                continue
            
            total_answers_processed += 1
            
            # Use smart matching
            matched_answer_objs = smart_match_answers(answer_text, answer_map[question_id], question_type)
            
            if not matched_answer_objs:
                unmapped_answers_count += 1
                continue
            
            # Extract answer IDs and weights
            answer_ids = [ans['answer_id'] for ans in matched_answer_objs]
            answer_weights_sum = sum(ans['answer_weight'] for ans in matched_answer_objs)
            
            # Store answer IDs
            col_name = f"q{question_id}_answer_id"
            if col_name not in answer_id_data:
                answer_id_data[col_name] = [None] * len(df)
            
            answer_id_data[col_name][idx] = ','.join(map(str, answer_ids))
            
            # Calculate score
            if question_type == 'Checklist':
                capped_sum = min(answer_weights_sum, 100)
                scaled_value = (capped_sum / 100) * 4 + 1
                question_score = (scaled_value * question_weight) / 100
            else:
                question_score = (answer_weights_sum * question_weight) / 100
            
            company_score += question_score
        
        total_scores.append(company_score)
    
    # Create output dataframes
    df_answer_ids = pd.DataFrame(answer_id_data)
    df_scores = pd.DataFrame({
        'company_id': company_ids,
        'total_score': total_scores
    })
    
    # Report
    print("\n" + "="*80)
    print("PROCESSING REPORT")
    print("="*80)
    print(f"Total answers processed: {total_answers_processed}")
    print(f"Unmapped answers: {unmapped_answers_count} ({unmapped_answers_count/total_answers_processed*100:.1f}%)")
    print(f"Output columns: {len(df_answer_ids.columns)} (should be {len(questions) + 1})")
    
    return df_answer_ids, df_scores

def main():
    print("="*80)
    print("ASSESSMENT DATA PROCESSING (POSITIONAL MATCHING)")
    print("="*80)
    
    # Fetch data
    print("\n1. Fetching questions and answers from database...")
    questions, answers = fetch_questions_and_answers()
    print(f"   Fetched {len(questions)} questions and {len(answers)} answers")
    
    # Create mappings
    print("\n2. Creating answer mappings...")
    answer_map = create_answer_map(answers)
    
    # Process CSV with positional matching
    print("\n3. Processing CSV data (POSITIONAL MATCHING)...")
    csv_path = 'AI_Compass_data_generation_2/assessment_data.csv'
    df_answer_ids, df_scores = process_csv_data_positional(csv_path, questions, answer_map)
    
    # Save output files
    print("\n4. Saving output files...")
    output_file_1 = 'DB_Tables_Raw/assessment_processing/company_answers_with_ids_v3.csv'
    output_file_2 = 'DB_Tables_Raw/assessment_processing/company_total_scores_v3.csv'
    
    df_answer_ids.to_csv(output_file_1, index=False)
    print(f"   Saved: {output_file_1} ({len(df_answer_ids)} rows, {len(df_answer_ids.columns)} columns)")
    
    df_scores.to_csv(output_file_2, index=False)
    print(f"   Saved: {output_file_2} ({len(df_scores)} rows)")
    
    # Display sample
    print("\n" + "="*80)
    print("SAMPLE RESULTS")
    print("="*80)
    print("\nFirst 3 rows (first 10 columns):")
    print(df_answer_ids.head(3).iloc[:, :10].to_string())
    
    print("\n\nScore statistics:")
    print(df_scores['total_score'].describe())
    
    print("\n" + "="*80)
    print("PROCESSING COMPLETE!")
    print("="*80)

if __name__ == "__main__":
    main()
