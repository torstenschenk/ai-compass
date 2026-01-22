import pandas as pd
import psycopg2
from dotenv import load_dotenv
import os
from pathlib import Path

# Load environment variables from project root
env_path = Path(__file__).resolve().parents[2] / '.env'
load_dotenv(dotenv_path=env_path)

def update_scores():
    print("Connecting to database...")
    try:
        conn = psycopg2.connect(
            user=os.getenv("user"),
            password=os.getenv("password"),
            host=os.getenv("host"),
            port=os.getenv("port"),
            dbname=os.getenv("dbname")
        )
        cur = conn.cursor()
        
        csv_path = 'DB_Tables_Raw/assessment_processing/company_total_scores_v4.csv'
        print(f"Reading {csv_path}...")
        df = pd.read_csv(csv_path)
        print(f"Loaded {len(df)} scores.")
        
        updates = 0
        errors = 0
        
        for idx, row in df.iterrows():
            try:
                company_id = int(row['company_id'])
                total_score = str(row['total_score']) # Convert to string as per schema
                
                cur.execute("""
                    UPDATE responses 
                    SET total_score = %s 
                    WHERE company_id = %s;
                """, (total_score, company_id))
                updates += 1
                    
            except Exception as e:
                print(f"Error processing row {idx} (Company {row.get('company_id')}): {e}")
                errors += 1
        
        conn.commit()
        print(f"\nUpdate complete.")
        print(f"Updated: {updates} rows")
        print(f"Errors/Skipped: {errors}")
        
        cur.close()
        conn.close()
        
    except Exception as e:
        print(f"Database error: {e}")

if __name__ == "__main__":
    update_scores()
