import psycopg2
from psycopg2 import extras
from dotenv import load_dotenv
import os
import pandas as pd
import numpy as np
from collections import defaultdict

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
    
    # Fetch questions
    cur.execute("SELECT * FROM questions ORDER BY question_id;")
    questions = cur.fetchall()
    
    # Fetch answers
    cur.execute("SELECT * FROM answers ORDER BY question_id, answer_id;")
    answers = cur.fetchall()
    
    cur.close()
    conn.close()
    
    return questions, answers

def create_mappings(questions, answers):
    """Create mapping dictionaries for questions and answers."""
    # Question text to question object
    question_text_to_obj = {q['question_text']: q for q in questions}
    
    # Answer text to answer object (grouped by question_id)
    answer_map = defaultdict(dict)
    for ans in answers:
        qid = ans['question_id']
        answer_map[qid][ans['answer_text']] = ans
    
    return question_text_to_obj, answer_map

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
        # This handles cases where answer text contains commas
        
        matched_answers = []
        remaining_text = answer_text_csv
        
        # Sort answers by length (longest first) to match longer texts first
        sorted_answers = sorted(answer_map_for_question.items(), key=lambda x: len(x[0]), reverse=True)
        
        # Keep trying to find matches until no more text remains
        max_iterations = 20  # Prevent infinite loops
        iteration = 0
        
        while remaining_text.strip() and iteration < max_iterations:
            iteration += 1
            found_match = False
            
            for ans_text, ans_obj in sorted_answers:
                # Check if this answer text appears in remaining text
                if ans_text in remaining_text:
                    matched_answers.append(ans_obj)
                    # Remove this answer from remaining text
                    remaining_text = remaining_text.replace(ans_text, '', 1)
                    # Remove leading/trailing commas and spaces
                    remaining_text = remaining_text.strip(', ')
                    found_match = True
                    break
            
            if not found_match:
                # No more matches found, stop
                break
        
        if matched_answers:
            return matched_answers
    
    # If no match found, return empty list
    return []

def process_csv_data(csv_path, question_text_to_obj, answer_map):
    """Process CSV and map to IDs."""
    print(f"Loading CSV from {csv_path}...")
    df = pd.read_csv(csv_path)
    
    print(f"Loaded {len(df)} rows")
    
    # Get question columns (H onwards, index 7+)
    question_cols = df.columns[7:].tolist()
    
    print(f"Found {len(question_cols)} question columns")
    
    # Prepare output dataframes
    company_ids = df.iloc[:, 0].values  # First column is Company_ID
    
    # For CSV 1: company_id + answer_ids for each question
    answer_id_data = {'company_id': company_ids}
    
    # For CSV 2: company_id + total_score
    total_scores = []
    
    # Track unmapped items
    unmapped_questions = []
    unmapped_answers = defaultdict(set)
    
    print("\nProcessing each company...")
    
    for idx, row in df.iterrows():
        if idx % 100 == 0:
            print(f"  Processing row {idx}/{len(df)}")
        
        company_score = 0.0
        
        for col_idx, question_text in enumerate(question_cols):
            # Map question text to question object
            if question_text not in question_text_to_obj:
                if question_text not in unmapped_questions:
                    unmapped_questions.append(question_text)
                continue
            
            question_obj = question_text_to_obj[question_text]
            question_id = question_obj['question_id']
            question_type = question_obj['type']
            question_weight = question_obj['weight']
            
            # Get answer text from CSV
            answer_text = row.iloc[7 + col_idx]
            
            # Handle NaN/missing values
            if pd.isna(answer_text):
                continue
            
            # Use smart matching
            matched_answer_objs = smart_match_answers(answer_text, answer_map[question_id], question_type)
            
            if not matched_answer_objs:
                unmapped_answers[question_text].add(str(answer_text)[:100])
                continue
            
            # Extract answer IDs and weights
            answer_ids = [ans['answer_id'] for ans in matched_answer_objs]
            answer_weights_sum = sum(ans['answer_weight'] for ans in matched_answer_objs)
            
            # Store answer IDs (comma-separated if multiple)
            col_name = f"q{question_id}_answer_id"
            if col_name not in answer_id_data:
                answer_id_data[col_name] = [None] * len(df)
            
            answer_id_data[col_name][idx] = ','.join(map(str, answer_ids))
            
            # Calculate score for this question
            if question_type == 'Checklist':
                # Checklist: sum weights (max 100), scale to 1-5, multiply by question weight, divide by 100
                capped_sum = min(answer_weights_sum, 100)
                scaled_value = (capped_sum / 100) * 4 + 1  # Scale to 1-5
                question_score = (scaled_value * question_weight) / 100
            else:
                # Other types: answer_weight * question_weight / 100
                question_score = (answer_weights_sum * question_weight) / 100
            
            company_score += question_score
        
        total_scores.append(company_score)
    
    # Create output dataframes
    df_answer_ids = pd.DataFrame(answer_id_data)
    df_scores = pd.DataFrame({
        'company_id': company_ids,
        'total_score': total_scores
    })
    
    # Report unmapped items
    print("\n" + "="*80)
    print("MAPPING REPORT")
    print("="*80)
    
    if unmapped_questions:
        print(f"\nUnmapped questions ({len(unmapped_questions)}):")
        for q in unmapped_questions:
            print(f"  - {q[:100]}")
    else:
        print("\nAll questions mapped successfully!")
    
    if unmapped_answers:
        print(f"\nUnmapped answers ({len(unmapped_answers)} questions with unmapped answers):")
        for q, answers in list(unmapped_answers.items())[:10]:
            print(f"\n  Question: {q[:80]}")
            for a in list(answers)[:5]:
                print(f"    - {a}")
    else:
        print("\nAll answers mapped successfully!")
    
    print("\n" + "="*80)
    
    return df_answer_ids, df_scores

def main():
    print("="*80)
    print("ASSESSMENT DATA PROCESSING (FIXED VERSION)")
    print("="*80)
    
    # Fetch data from database
    print("\n1. Fetching questions and answers from database...")
    questions, answers = fetch_questions_and_answers()
    print(f"   Fetched {len(questions)} questions and {len(answers)} answers")
    
    # Create mappings
    print("\n2. Creating mapping dictionaries...")
    question_text_to_obj, answer_map = create_mappings(questions, answers)
    
    # Process CSV
    print("\n3. Processing CSV data...")
    csv_path = 'AI_Compass_data_generation_2/assessment_data.csv'
    df_answer_ids, df_scores = process_csv_data(csv_path, question_text_to_obj, answer_map)
    
    # Save output files
    print("\n4. Saving output files...")
    output_file_1 = 'DB_Tables_Raw/assessment_processing/company_answers_with_ids_v2.csv'
    output_file_2 = 'DB_Tables_Raw/assessment_processing/company_total_scores_v2.csv'
    
    df_answer_ids.to_csv(output_file_1, index=False)
    print(f"   Saved: {output_file_1} ({len(df_answer_ids)} rows)")
    
    df_scores.to_csv(output_file_2, index=False)
    print(f"   Saved: {output_file_2} ({len(df_scores)} rows)")
    
    # Display sample results
    print("\n" + "="*80)
    print("SAMPLE RESULTS")
    print("="*80)
    
    print("\nFirst 3 rows of company_answers_with_ids.csv:")
    print(df_answer_ids.head(3).to_string())
    
    print("\n\nFirst 10 rows of company_total_scores.csv:")
    print(df_scores.head(10).to_string())
    
    print("\n\nScore statistics:")
    print(df_scores['total_score'].describe())
    
    print("\n" + "="*80)
    print("PROCESSING COMPLETE!")
    print("="*80)

if __name__ == "__main__":
    main()
