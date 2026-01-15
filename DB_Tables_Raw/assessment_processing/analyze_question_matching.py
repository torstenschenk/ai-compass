import pandas as pd
import psycopg2
from psycopg2 import extras
from dotenv import load_dotenv
import os

load_dotenv()

# Load CSV
df = pd.read_csv('AI_Compass_data_generation_2/assessment_data.csv')

# Connect to DB
conn = psycopg2.connect(
    user=os.getenv("user"),
    password=os.getenv("password"),
    host=os.getenv("host"),
    port=os.getenv("port"),
    dbname=os.getenv("dbname")
)
cur = conn.cursor(cursor_factory=extras.RealDictCursor)

# Get all questions from DB
cur.execute("SELECT question_id, question_text FROM questions ORDER BY question_id;")
db_questions = cur.fetchall()

# Get question columns from CSV
csv_question_cols = df.columns[7:].tolist()

print("="*80)
print("QUESTION MATCHING ANALYSIS")
print("="*80)

print(f"\nQuestions in database: {len(db_questions)}")
print(f"Question columns in CSV: {len(csv_question_cols)}")

# Try to match
matched = []
unmatched_db = []
unmatched_csv = []

for db_q in db_questions:
    if db_q['question_text'] in csv_question_cols:
        matched.append(db_q['question_id'])
    else:
        unmatched_db.append((db_q['question_id'], db_q['question_text']))

for csv_q in csv_question_cols:
    found = False
    for db_q in db_questions:
        if db_q['question_text'] == csv_q:
            found = True
            break
    if not found:
        unmatched_csv.append(csv_q)

print(f"\nMatched questions: {len(matched)}")
print(f"Unmatched DB questions: {len(unmatched_db)}")
print(f"Unmatched CSV questions: {len(unmatched_csv)}")

if unmatched_db:
    print("\n" + "="*80)
    print("DB QUESTIONS NOT FOUND IN CSV:")
    print("="*80)
    for qid, qtext in unmatched_db:
        print(f"\nQ{qid}: {qtext[:100]}...")
        # Try to find similar in CSV
        for csv_q in csv_question_cols:
            if csv_q[:50] in qtext or qtext[:50] in csv_q:
                print(f"  Possible match in CSV: {csv_q[:100]}...")

if unmatched_csv:
    print("\n" + "="*80)
    print("CSV QUESTIONS NOT FOUND IN DB:")
    print("="*80)
    for qtext in unmatched_csv:
        print(f"\n{qtext[:100]}...")

cur.close()
conn.close()
