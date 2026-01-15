import pandas as pd
import psycopg2
from psycopg2 import extras
from dotenv import load_dotenv
import os

load_dotenv()

# Load files
df_original = pd.read_csv('AI_Compass_data_generation_2/assessment_data.csv')
df_answers = pd.read_csv('DB_Tables_Raw/assessment_processing/company_answers_with_ids.csv')
df_scores = pd.read_csv('DB_Tables_Raw/assessment_processing/company_total_scores.csv')

# Connect to DB
conn = psycopg2.connect(
    user=os.getenv("user"),
    password=os.getenv("password"),
    host=os.getenv("host"),
    port=os.getenv("port"),
    dbname=os.getenv("dbname")
)
cur = conn.cursor(cursor_factory=extras.RealDictCursor)

# Fetch questions and answers
cur.execute("SELECT * FROM questions ORDER BY question_id;")
questions = {q['question_id']: q for q in cur.fetchall()}

cur.execute("SELECT * FROM answers ORDER BY answer_id;")
answers = {a['answer_id']: a for a in cur.fetchall()}

print("="*80)
print("DETAILED SCORE VERIFICATION FOR COMPANY 320")
print("="*80)

# Check first company (ID 320, row 0)
company_id = 320
row_idx = 0

total_score_from_csv = df_scores[df_scores['company_id'] == company_id]['total_score'].values[0]
print(f"\nTotal Score from CSV: {total_score_from_csv}")

# Manual calculation
manual_total = 0.0
question_count = 0

print("\n" + "="*80)
print("QUESTION-BY-QUESTION BREAKDOWN")
print("="*80)

# Get all question columns from original CSV (starting at column 7)
question_cols = df_original.columns[7:].tolist()
print(f"\nTotal question columns in CSV: {len(question_cols)}")

for col_idx, question_text in enumerate(question_cols):
    # Find question in DB
    question_obj = None
    for qid, q in questions.items():
        if q['question_text'] == question_text:
            question_obj = q
            break
    
    if not question_obj:
        print(f"\nQ{col_idx+1}: NOT FOUND IN DB")
        print(f"  Question: {question_text[:80]}")
        continue
    
    qid = question_obj['question_id']
    qtype = question_obj['type']
    qweight = question_obj['weight']
    
    # Get answer from original CSV
    answer_text = df_original.iloc[row_idx, 7 + col_idx]
    
    if pd.isna(answer_text):
        print(f"\nQ{qid} ({qtype}): NO ANSWER")
        continue
    
    # Get answer IDs from processed CSV
    answer_id_col = f"q{qid}_answer_id"
    if answer_id_col not in df_answers.columns:
        print(f"\nQ{qid} ({qtype}): COLUMN NOT FOUND IN OUTPUT")
        continue
    
    answer_ids_str = df_answers.iloc[row_idx][answer_id_col]
    
    if pd.isna(answer_ids_str):
        print(f"\nQ{qid} ({qtype}): NO ANSWER ID MAPPED")
        continue
    
    # Parse answer IDs
    answer_ids = [int(float(aid)) for aid in str(answer_ids_str).split(',')]
    
    # Calculate score
    answer_weights_sum = sum(answers[aid]['answer_weight'] for aid in answer_ids if aid in answers)
    
    if qtype == 'Checklist':
        capped_sum = min(answer_weights_sum, 100)
        scaled_value = (capped_sum / 100) * 4 + 1
        q_score = (scaled_value * qweight) / 100
    else:
        q_score = (answer_weights_sum * qweight) / 100
    
    manual_total += q_score
    question_count += 1
    
    print(f"\nQ{qid} ({qtype}, weight={qweight}):")
    print(f"  Answer: {str(answer_text)[:60]}")
    print(f"  Answer IDs: {answer_ids}")
    print(f"  Answer Weight Sum: {answer_weights_sum}")
    print(f"  Question Score: {q_score:.6f}")
    print(f"  Running Total: {manual_total:.6f}")

print("\n" + "="*80)
print("SUMMARY")
print("="*80)
print(f"Questions processed: {question_count}")
print(f"Manual calculated total: {manual_total:.6f}")
print(f"CSV total score: {total_score_from_csv:.6f}")
print(f"Difference: {abs(manual_total - total_score_from_csv):.6f}")

cur.close()
conn.close()
