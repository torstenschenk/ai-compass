import pandas as pd
import psycopg2
from psycopg2 import extras
from dotenv import load_dotenv
import os

load_dotenv()

# Connect to database
conn = psycopg2.connect(
    user=os.getenv("user"),
    password=os.getenv("password"),
    host=os.getenv("host"),
    port=os.getenv("port"),
    dbname=os.getenv("dbname")
)
cur = conn.cursor(cursor_factory=extras.RealDictCursor)

# Load original CSV and output files
df_original = pd.read_csv('AI_Compass_data_generation_2/assessment_data.csv')
df_answers = pd.read_csv('company_answers_with_ids.csv')
df_scores = pd.read_csv('company_total_scores.csv')

# Fetch questions and answers from DB
cur.execute("SELECT * FROM questions ORDER BY question_id;")
questions = {q['question_id']: q for q in cur.fetchall()}

cur.execute("SELECT * FROM answers ORDER BY answer_id;")
answers = {a['answer_id']: a for a in cur.fetchall()}

print("="*80)
print("DETAILED VERIFICATION - SAMPLE COMPANIES")
print("="*80)

# Verify 3 sample companies
sample_indices = [0, 100, 250]

for idx in sample_indices:
    company_id = df_original.iloc[idx, 0]
    print(f"\n{'='*80}")
    print(f"COMPANY ID: {company_id} (Row {idx})")
    print(f"{'='*80}")
    
    # Get total score
    total_score = df_scores[df_scores['company_id'] == company_id]['total_score'].values[0]
    print(f"\nTotal Score: {total_score:.4f}")
    
    # Calculate score manually for verification
    manual_score = 0.0
    
    print("\nQuestion-by-Question Breakdown:")
    print("-" * 80)
    
    # Check first 5 questions
    for q_col_idx in range(5):
        question_text = df_original.columns[7 + q_col_idx]
        answer_text = df_original.iloc[idx, 7 + q_col_idx]
        
        # Find question in DB
        question_obj = None
        for qid, q in questions.items():
            if q['question_text'] == question_text:
                question_obj = q
                break
        
        if not question_obj:
            continue
        
        qid = question_obj['question_id']
        qtype = question_obj['type']
        qweight = question_obj['weight']
        
        # Get answer ID from output
        answer_id_col = f"q{qid}_answer_id"
        if answer_id_col in df_answers.columns:
            answer_ids_str = df_answers.iloc[idx][answer_id_col]
            
            if pd.notna(answer_ids_str):
                answer_ids = [int(aid) for aid in str(answer_ids_str).split(',')]
                
                # Calculate score
                answer_weights_sum = sum(answers[aid]['answer_weight'] for aid in answer_ids if aid in answers)
                
                if qtype == 'Checklist':
                    capped_sum = min(answer_weights_sum, 100)
                    scaled_value = (capped_sum / 100) * 4 + 1
                    q_score = (scaled_value * qweight) / 100
                else:
                    q_score = (answer_weights_sum * qweight) / 100
                
                manual_score += q_score
                
                print(f"\nQ{qid} ({qtype}): {question_text[:60]}...")
                print(f"  Answer: {str(answer_text)[:60]}...")
                print(f"  Answer IDs: {answer_ids}")
                print(f"  Answer Weight(s): {answer_weights_sum}")
                print(f"  Question Weight: {qweight}")
                print(f"  Question Score: {q_score:.4f}")
    
    print(f"\n{'-'*80}")
    print(f"Manual Score (first 5 questions only): {manual_score:.4f}")
    print(f"Full Total Score from output: {total_score:.4f}")

cur.close()
conn.close()

print("\n" + "="*80)
print("VERIFICATION COMPLETE")
print("="*80)
