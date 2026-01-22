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
    
    cur.execute("SELECT COUNT(*) FROM response_items;")
    items = cur.fetchone()[0]
    
    cur.execute("SELECT COUNT(*) FROM responses;")
    resps = cur.fetchone()[0]
    
    print(f"Response items: {items}")
    print(f"Responses: {resps}")
    
    cur.close()
    conn.close()

except Exception as e:
    print(f"Error: {e}")
