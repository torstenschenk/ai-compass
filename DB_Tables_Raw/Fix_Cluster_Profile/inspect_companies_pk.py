
import psycopg2
from dotenv import load_dotenv
import os

load_dotenv()

def inspect_companies():
    try:
        conn = psycopg2.connect(
            user=os.getenv("user"), 
            password=os.getenv("password"), 
            host=os.getenv("host"), 
            port=os.getenv("port"), 
            dbname=os.getenv("dbname")
        )
        cur = conn.cursor()
        
        cur.execute("SELECT column_name, data_type FROM information_schema.columns WHERE table_name = 'companies'")
        cols = cur.fetchall()
        
        with open("companies_cols.txt", "w") as f:
            for row in cols:
                f.write(f"'{row[0]}' ({row[1]})\n")
            
        conn.close()
    except Exception as e:
        with open("companies_cols.txt", "w") as f:
            f.write(str(e))

if __name__ == "__main__":
    inspect_companies()
