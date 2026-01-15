import psycopg2
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
conn.autocommit = True
cur = conn.cursor()

print("Checking row counts...")
cur.execute("SELECT COUNT(*) FROM response_items;")
print(f"Response items: {cur.fetchone()[0]}")
cur.execute("SELECT COUNT(*) FROM responses;")
print(f"Responses: {cur.fetchone()[0]}")

print("\nDeleting data...")
try:
    cur.execute("DELETE FROM response_items;")
    print("Deleted response_items.")
    
    cur.execute("DELETE FROM responses;")
    print("Deleted responses.")
    
    # Optional: Reset sequences if possible (but we use manual IDs so not strictly needed, 
    # but good to reset logic in upload script)
    # cur.execute("ALTER SEQUENCE responses_response_id_seq RESTART WITH 1;") 
    
except Exception as e:
    print(f"Error: {e}")

print("\nVerifying empty...")
cur.execute("SELECT COUNT(*) FROM response_items;")
print(f"Response items: {cur.fetchone()[0]}")
cur.execute("SELECT COUNT(*) FROM responses;")
print(f"Responses: {cur.fetchone()[0]}")

cur.close()
conn.close()
