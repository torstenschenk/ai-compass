
import os
import psycopg2
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

db_url = os.getenv("DATABASE_URL")
if not db_url:
    print("Error: DATABASE_URL not found in .env")
    exit(1)

print(f"Connecting to: {db_url.split('@')[-1]}") # Print host only for security

try:
    conn = psycopg2.connect(db_url)
    cur = conn.cursor()
    print("✓ Connection successful.")
    
    # List all tables
    print("Listing all tables and row counts:")
    cur.execute("""
        SELECT table_name 
        FROM information_schema.tables 
        WHERE table_schema = 'public';
    """)
    tables = cur.fetchall()
    
    for t in tables:
        table = t[0]
        cur.execute(f"SELECT count(*) FROM {table}")
        count = cur.fetchone()[0]
        print(f" - {table}: {count} rows")

    # If 'assessments' or similar exists, show a sample
    target_table = None
    for t in tables:
        if 'assessment' in t[0] or 'response' in t[0] or 'company' in t[0] or 'data' in t[0]:
            target_table = t[0]
            break
            
    if target_table:
        print(f"\n--- Sample from '{target_table}' ---")
        cur.execute(f"SELECT * FROM {target_table} LIMIT 3;")
        rows = cur.fetchall()
        colnames = [desc[0] for desc in cur.description]
        print(f"{' | '.join(colnames)}")
        for row in rows:
            print(" | ".join(str(item) for item in row))


    cur.close()
    conn.close()

except Exception as e:
    print(f"❌ Database Error: {e}")
