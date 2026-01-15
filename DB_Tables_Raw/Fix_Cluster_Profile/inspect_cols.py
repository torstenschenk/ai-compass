
import psycopg2
from dotenv import load_dotenv
import os

load_dotenv()

def list_columns():
    try:
        conn = psycopg2.connect(
            user=os.getenv("user"), 
            password=os.getenv("password"), 
            host=os.getenv("host"), 
            port=os.getenv("port"), 
            dbname=os.getenv("dbname")
        )
        cur = conn.cursor()
        
        for table in ['companies', 'responses']:
            cur.execute(f"SELECT column_name, data_type FROM information_schema.columns WHERE table_name = '{table}'")
            print(f"\n--- {table} Columns ---")
            for row in cur.fetchall():
                print(f"{row[0]}: {row[1]}")
                
        conn.close()
    except Exception as e:
        print(e)

if __name__ == "__main__":
    list_columns()
