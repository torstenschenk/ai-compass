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
    
    cur.execute("""
        SELECT column_name 
        FROM information_schema.columns 
        WHERE table_name = 'responses';
    """)
    columns = cur.fetchall()
    print("Columns in responses table:")
    for col in columns:
        print(f" - {col[0]}")
    
    cur.close()
    conn.close()

except Exception as e:
    print(f"Error: {e}")
