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

# Get questions
cur.execute("SELECT * FROM questions ORDER BY question_id;")
questions = cur.fetchall()

# Missing question IDs
missing_qids = [13, 18, 28, 30]

print("="*80)
print("INVESTIGATING MISSING QUESTIONS")
print("="*80)

for qid in missing_qids:
    question_obj = questions[qid - 1]  # 0-indexed
    
    print(f"\n{'='*80}")
    print(f"QUESTION {qid}")
    print(f"{'='*80}")
    print(f"Type: {question_obj['type']}")
    print(f"Text: {question_obj['question_text'][:100]}...")
    
    # Get answers from DB
    cur.execute(f"SELECT * FROM answers WHERE question_id = {qid};")
    db_answers = cur.fetchall()
    
    print(f"\nDatabase has {len(db_answers)} answers:")
    for ans in db_answers[:5]:
        print(f"  - {ans['answer_text'][:80]}")
    
    # Get CSV column (position-based)
    csv_col_idx = qid - 1  # Questions start at index 0 in CSV question columns
    csv_column = df.columns[7 + csv_col_idx]
    
    print(f"\nCSV column name: {csv_column[:100]}...")
    
    # Get sample answers from CSV
    print(f"\nSample CSV answers (first 5 companies):")
    for i in range(5):
        csv_answer = df.iloc[i, 7 + csv_col_idx]
        print(f"  Company {df.iloc[i, 0]}: {str(csv_answer)[:80]}")

cur.close()
conn.close()
