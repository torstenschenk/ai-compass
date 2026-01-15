import pandas as pd
import psycopg2
from psycopg2 import extras
from dotenv import load_dotenv
import os

load_dotenv()

# Connect to DB
conn = psycopg2.connect(
    user=os.getenv("user"),
    password=os.getenv("password"),
    host=os.getenv("host"),
    port=os.getenv("port"),
    dbname=os.getenv("dbname")
)
cur = conn.cursor(cursor_factory=extras.RealDictCursor)

# Fetch questions
cur.execute("SELECT * FROM questions ORDER BY question_id;")
questions = cur.fetchall()

print("="*80)
print("QUESTION WEIGHTS ANALYSIS")
print("="*80)

total_weight = 0
for q in questions:
    print(f"Q{q['question_id']} ({q['type']}): weight = {q['weight']}")
    total_weight += q['weight']

print(f"\nTotal of all question weights: {total_weight}")

print("\n" + "="*80)
print("SCORING FORMULA ANALYSIS")
print("="*80)

print("\nCurrent formula:")
print("  Checklist: (scaled_value * question_weight) / 100")
print("  Others: (answer_weight * question_weight) / 100")

print("\nExample calculation for a Statement question:")
print("  Question weight: 4.5")
print("  Answer weight: 5 (max)")
print("  Score: (5 * 4.5) / 100 = 0.225")

print("\nIf all 33 questions had max scores:")
print("  With current formula (dividing by 100):")
max_score_current = 0
for q in questions:
    if q['type'] == 'Checklist':
        # Max for checklist: scaled to 5, then multiply by weight, divide by 100
        max_score_current += (5 * q['weight']) / 100
    else:
        # Max for others: answer_weight 5, multiply by weight, divide by 100
        max_score_current += (5 * q['weight']) / 100

print(f"    Max possible total score: {max_score_current:.2f}")

print("\n  Without dividing by 100:")
max_score_no_div = 0
for q in questions:
    max_score_no_div += 5 * q['weight']

print(f"    Max possible total score: {max_score_no_div:.2f}")

print("\n" + "="*80)
print("QUESTION")
print("="*80)
print("\nShould the final score be:")
print("  A) Around 1-5 (current implementation with /100)")
print("  B) Around 100-500 (without /100)")
print("  C) Something else?")

cur.close()
conn.close()
