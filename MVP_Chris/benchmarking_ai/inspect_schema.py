
import psycopg2
from psycopg2 import extras
from dotenv import load_dotenv
import os
import pandas as pd

load_dotenv()

def inspect_schema():
    try:
        conn = psycopg2.connect(
            user=os.getenv("user"), 
            password=os.getenv("password"), 
            host=os.getenv("host"), 
            port=os.getenv("port"), 
            dbname=os.getenv("dbname")
        )
        cur = conn.cursor(cursor_factory=extras.RealDictCursor) # Use DictCursor for readability
        
        # 1. Get Tables
        cur.execute("SELECT table_name FROM information_schema.tables WHERE table_schema = 'public'")
        tables = [t['table_name'] for t in cur.fetchall()]
        print(f"Tables Found: {tables}")
        
        # 2. Inspect specific tables for AI relevance
        print("\n=== Table Inspection ===")
        for table in tables:
            print(f"\n--- Table: {table} ---")
            
            # Columns
            cur.execute(f"SELECT column_name, data_type FROM information_schema.columns WHERE table_name = '{table}'")
            cols = cur.fetchall()
            col_list = [f"{c['column_name']} ({c['data_type']})" for c in cols]
            print(f"Columns: {col_list}")
            
            # Sample Data
            cur.execute(f"SELECT * FROM {table} LIMIT 3")
            samples = cur.fetchall()
            if samples:
                df = pd.DataFrame(samples)
                print(f"Sample Data (First 3 rows):")
                print(df.to_string(index=False))
            else:
                print("No data found.")
                
        conn.close()
    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    inspect_schema()
