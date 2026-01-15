import psycopg2
from psycopg2 import extras
from dotenv import load_dotenv
import os
import json

load_dotenv()

conn = psycopg2.connect(
    user=os.getenv("user"),
    password=os.getenv("password"),
    host=os.getenv("host"),
    port=os.getenv("port"),
    dbname=os.getenv("dbname")
)

cur = conn.cursor(cursor_factory=extras.RealDictCursor)

# Fetch all questions
cur.execute("SELECT * FROM questions ORDER BY question_id;")
questions = cur.fetchall()

# Fetch all answers
cur.execute("SELECT * FROM answers ORDER BY question_id, answer_id;")
answers = cur.fetchall()

output = {
    'questions': questions,
    'answers': answers
}

# Save to JSON
with open('db_questions_answers.json', 'w', encoding='utf-8') as f:
    json.dump(output, f, indent=2, default=str, ensure_ascii=False)

print(f"Fetched {len(questions)} questions")
print(f"Fetched {len(answers)} answers")
print("Saved to db_questions_answers.json")

# Show question types
question_types = {}
for q in questions:
    qtype = q['type']
    question_types[qtype] = question_types.get(qtype, 0) + 1

print("\nQuestion types:")
for qtype, count in question_types.items():
    print(f"  {qtype}: {count}")

cur.close()
conn.close()
