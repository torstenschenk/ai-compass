import pandas as pd
import psycopg2
from psycopg2 import extras
from dotenv import load_dotenv
import os

load_dotenv()

# Load files
df_original = pd.read_csv('AI_Compass_data_generation_2/assessment_data.csv')
df_scores = pd.read_csv('DB_Tables_Raw/assessment_processing/company_total_scores.csv')
df_answers = pd.read_csv('DB_Tables_Raw/assessment_processing/company_answers_with_ids.csv')

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
print("VERIFICATION OF SAMPLE COMPANIES")
print("="*80)

# Select 3 random companies: low, medium, high score
low_score_company = df_scores.nsmallest(1, 'total_score').iloc[0]
mid_score_company = df_scores.iloc[len(df_scores)//2]
high_score_company = df_scores.nlargest(1, 'total_score').iloc[0]

samples = [
    ("LOWEST SCORE", low_score_company),
    ("MEDIAN SCORE", mid_score_company),
    ("HIGHEST SCORE", high_score_company)
]

for label, company_row in samples:
    company_id = company_row['company_id']
    csv_score = company_row['total_score']
    
    # Find row in original CSV
    orig_row_idx = df_original[df_original.iloc[:, 0] == company_id].index[0]
    
    print(f"\n{'='*80}")
    print(f"{label}: Company {company_id}")
    print(f"{'='*80}")
    print(f"CSV Total Score: {csv_score:.6f}")
    
    # Manual calculation
    manual_total = 0.0
    question_count = 0
    
    question_cols = df_original.columns[7:].tolist()
    
    for col_idx, question_text in enumerate(question_cols):
        # Find question
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
        
        # Get answer
        answer_text = df_original.iloc[orig_row_idx, 7 + col_idx]
        if pd.isna(answer_text):
            continue
        
        # Get answer IDs
        answer_id_col = f"q{qid}_answer_id"
        if answer_id_col not in df_answers.columns:
            continue
        
        answer_ids_str = df_answers.iloc[orig_row_idx][answer_id_col]
        if pd.isna(answer_ids_str):
            continue
        
        answer_ids = [int(float(aid)) for aid in str(answer_ids_str).split(',')]
        answer_weights_sum = sum(answers[aid]['answer_weight'] for aid in answer_ids if aid in answers)
        
        if qtype == 'Checklist':
            capped_sum = min(answer_weights_sum, 100)
            scaled_value = (capped_sum / 100) * 4 + 1
            q_score = (scaled_value * qweight) / 100
        else:
            q_score = (answer_weights_sum * qweight) / 100
        
        manual_total += q_score
        question_count += 1
    
    print(f"Manual Calculated Score: {manual_total:.6f}")
    print(f"Difference: {abs(csv_score - manual_total):.10f}")
    print(f"Questions processed: {question_count}/33")
    
    if abs(csv_score - manual_total) < 0.0001:
        print("✓ VERIFIED - Scores match!")
    else:
        print("✗ WARNING - Scores don't match!")

print("\n" + "="*80)
print("VERIFICATION COMPLETE")
print("="*80)

cur.close()
conn.close()
