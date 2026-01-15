import pandas as pd
import psycopg2
from psycopg2 import extras
from dotenv import load_dotenv
import os

load_dotenv()

# Load CSV
df_answers = pd.read_csv('DB_Tables_Raw/assessment_processing/company_answers_with_ids_v2.csv')

# Get first company (response_id 1)
first_company = df_answers.iloc[0]
company_id = first_company['company_id']

print(f"Investigating response_id 1 (company_id {company_id})")
print("="*80)

# Check which question columns exist
question_cols = [col for col in df_answers.columns if col.startswith('q') and col.endswith('_answer_id')]
print(f"\nTotal question columns in CSV: {len(question_cols)}")

# Extract question IDs from column names
question_ids_in_csv = []
for col in question_cols:
    qid = int(col.split('_')[0][1:])
    question_ids_in_csv.append(qid)

question_ids_in_csv.sort()
print(f"Question IDs in CSV: {question_ids_in_csv}")

# Check which ones have values for first company
print(f"\nChecking first company's answers:")
missing_questions = []
present_questions = []

for col in question_cols:
    qid = int(col.split('_')[0][1:])
    value = first_company[col]
    
    if pd.isna(value):
        missing_questions.append(qid)
    else:
        present_questions.append(qid)

missing_questions.sort()
present_questions.sort()

print(f"\nQuestions WITH answers: {present_questions}")
print(f"Questions WITHOUT answers (NaN): {missing_questions}")

# Check if the reported missing questions are in the missing list
reported_missing = [13, 16, 18, 24, 26, 28, 30, 31]
print(f"\nReported missing from DB: {reported_missing}")
print(f"Are they NaN in CSV? {all(qid in missing_questions for qid in reported_missing)}")

# Connect to DB and check what's actually there
conn = psycopg2.connect(
    user=os.getenv("user"),
    password=os.getenv("password"),
    host=os.getenv("host"),
    port=os.getenv("port"),
    dbname=os.getenv("dbname")
)
cur = conn.cursor(cursor_factory=extras.RealDictCursor)

cur.execute("SELECT question_id FROM response_items WHERE response_id = 1 ORDER BY question_id;")
db_questions = [row['question_id'] for row in cur.fetchall()]

print(f"\nQuestion IDs in DB for response_id 1: {db_questions}")
print(f"Missing from DB: {[q for q in question_ids_in_csv if q not in db_questions]}")

cur.close()
conn.close()

print("\n" + "="*80)
print("CONCLUSION:")
print("="*80)
if all(qid in missing_questions for qid in reported_missing):
    print("The missing questions had NaN/empty values in the CSV file.")
    print("The upload script correctly skipped them (no answer to insert).")
else:
    print("ERROR: Some questions had values in CSV but weren't inserted!")
