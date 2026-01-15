
import psycopg2
from psycopg2 import extras
from dotenv import load_dotenv
import os
import pandas as pd

load_dotenv()

def dump_schema():
    try:
        conn = psycopg2.connect(
            user=os.getenv("user"), 
            password=os.getenv("password"), 
            host=os.getenv("host"), 
            port=os.getenv("port"), 
            dbname=os.getenv("dbname")
        )
        cur = conn.cursor(cursor_factory=extras.RealDictCursor)
        
        with open("benchmarking_ai/schema_dump.txt", "w", encoding="utf-8") as f:
            # 1. Get Tables
            cur.execute("SELECT table_name FROM information_schema.tables WHERE table_schema = 'public'")
            tables = [t['table_name'] for t in cur.fetchall()]
            f.write(f"Tables Found: {tables}\n\n")
            
            # 2. Inspect tables
            for table in tables:
                f.write(f"=== Table: {table} ===\n")
                
                # Columns
                cur.execute(f"SELECT column_name, data_type FROM information_schema.columns WHERE table_name = '{table}'")
                cols = cur.fetchall()
                col_list = [f"{c['column_name']} ({c['data_type']})" for c in cols]
                f.write(f"Columns: {col_list}\n")
                
                # Sample Data
                cur.execute(f"SELECT * FROM {table} LIMIT 3")
                samples = cur.fetchall()
                if samples:
                    df = pd.DataFrame(samples)
                    f.write(f"Sample Data:\n{df.to_string(index=False)}\n")
                else:
                    f.write("No data found.\n")
                f.write("\n" + "="*30 + "\n\n")
                
        conn.close()
    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    dump_schema()
