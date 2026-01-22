import psycopg2
from dotenv import load_dotenv
import os
from pathlib import Path

# Load environment variables from project root
env_path = Path(__file__).resolve().parents[2] / '.env'
load_dotenv(dotenv_path=env_path)

try:
    conn = psycopg2.connect(
        user=os.getenv("user"),
        password=os.getenv("password"),
        host=os.getenv("host"),
        port=os.getenv("port"),
        dbname=os.getenv("dbname")
    )
    cur = conn.cursor()
    
    cur.execute("SELECT COUNT(*) FROM responses WHERE total_score IS NOT NULL;")
    count = cur.fetchone()[0]
    
    cur.execute("SELECT COUNT(*) FROM responses;")
    total = cur.fetchone()[0]
    
    print(f"Responses with total_score: {count} / {total}")
    
    if count == total and total > 0:
        print("SUCCESS: All responses have a total_score.")
    elif total > 0:
        print(f"WARNING: {total - count} responses missing total_score.")
    else:
        print("No responses found in table.")
    
    cur.close()
    conn.close()

except Exception as e:
    print(f"Error: {e}")
