import pandas as pd
import psycopg2
from dotenv import load_dotenv
import os
from pathlib import Path
import re

# Load environment variables from project root
env_path = Path(__file__).resolve().parents[2] / '.env'
load_dotenv(dotenv_path=env_path)

def update_cluster_ids():
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
        
        print("Reading companies.csv...")
        # Read CSV - try utf-8 first, then fallback if needed (though excel often uses latin1 or cp1252)
        try:
            df = pd.read_csv('DB_Tables_Raw/companies.csv')
        except UnicodeDecodeError:
            df = pd.read_csv('DB_Tables_Raw/companies.csv', encoding='cp1252')
            
        print(f"Loaded {len(df)} companies.")
        
        updates = 0
        errors = 0
        
        for idx, row in df.iterrows():
            try:
                company_id = row['company_id']
                cluster_profile_str = row['cluster_profile']
                
                # Extract number from "1. The Traditionalist"
                # Match start of string, digit(s), dot/space
                match = re.match(r'(\d+)', str(cluster_profile_str))
                
                if match:
                    cluster_id = int(match.group(1))
                    
                    cur.execute("""
                        UPDATE responses 
                        SET cluster_id = %s 
                        WHERE company_id = %s;
                    """, (cluster_id, company_id))
                    updates += 1
                else:
                    print(f"Warning: Could not extract cluster ID from '{cluster_profile_str}' for company {company_id}")
                    errors += 1
                    
            except Exception as e:
                print(f"Error processing row {idx}: {e}")
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
    update_cluster_ids()
