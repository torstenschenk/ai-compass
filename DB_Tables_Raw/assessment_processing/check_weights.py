import psycopg2
from psycopg2 import extras
from dotenv import load_dotenv
import os

load_dotenv()

conn = psycopg2.connect(
    user=os.getenv("user"),
    password=os.getenv("password"),
    host=os.getenv("host"),
    port=os.getenv("port"),
    dbname=os.getenv("dbname")
)
cur = conn.cursor(cursor_factory=extras.RealDictCursor)

cur.execute("SELECT SUM(weight) as total_weight FROM questions;")
total_weight = cur.fetchone()['total_weight']

print(f"Sum of all question weights: {total_weight}")
print(f"\nCurrent scoring formula divides by 100 at the end.")
print(f"This means max possible score is around: {(5 * total_weight) / 100:.2f}")
print(f"\nWithout dividing by 100, max score would be: {5 * total_weight:.2f}")

cur.close()
conn.close()
