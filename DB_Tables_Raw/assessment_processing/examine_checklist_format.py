import pandas as pd
import psycopg2
from psycopg2 import extras
from dotenv import load_dotenv
import os
import sys

# Fix encoding for Windows console
sys.stdout.reconfigure(encoding='utf-8')

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

# Get a checklist question
cur.execute("SELECT * FROM questions WHERE type = 'Checklist' LIMIT 1;")
q = cur.fetchone()

print(f"Checklist Question: {q['question_text']}")

# Get its answers
cur.execute(f"SELECT * FROM answers WHERE question_id = {q['question_id']};")
answers = cur.fetchall()

print(f"\nDatabase has {len(answers)} possible answers for this question")
print("\nSample CSV values for this question (first 10 companies):")

if q['question_text'] in df.columns:
    col_idx = df.columns.get_loc(q['question_text'])
    for i in range(10):
        val = df.iloc[i, col_idx]
        print(f"{i+1}. '{val}'")

print("\n" + "="*80)
print("KEY INSIGHT:")
print("="*80)
print("The CSV values need to be matched against the FULL answer_text from database.")
print("For checklist questions with multiple selections, we need to:")
print("1. Try to match the entire CSV value as-is first")
print("2. If that fails, intelligently parse multiple answers")
print("3. Match each part against database answer_text")

cur.close()
conn.close()
