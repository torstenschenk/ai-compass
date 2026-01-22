import pandas as pd
import psycopg2
from psycopg2 import extras
from dotenv import load_dotenv
import os

from pathlib import Path

# Load environment variables from project root
env_path = Path(__file__).resolve().parents[2] / '.env'
load_dotenv(dotenv_path=env_path)

def get_db_connection():
    return psycopg2.connect(
        user=os.getenv("user"),
        password=os.getenv("password"),
        host=os.getenv("host"),
        port=os.getenv("port"),
        dbname=os.getenv("dbname")
    )

def clear_existing_data():
    """Clear responses and response_items tables."""
    conn = get_db_connection()
    cur = conn.cursor()
    
    print("Clearing existing data from responses and response_items tables...")
    try:
        cur.execute("TRUNCATE TABLE response_items, responses RESTART IDENTITY;")
        conn.commit()
        print("Tables cleared successfully.")
    except Exception as e:
        print(f"Error clearing tables: {e}")
        conn.rollback()
    finally:
        cur.close()
        conn.close()

def insert_data_to_database():
    """Insert data from V4 CSV files into database tables."""
    
    # Load V4 CSV files
    print("\nLoading V4 CSV files...")
    df_answers = pd.read_csv('DB_Tables_Raw/assessment_processing/company_answers_with_ids_v4.csv')
    df_scores = pd.read_csv('DB_Tables_Raw/assessment_processing/company_total_scores_v4.csv')
    
    print(f"  Loaded {len(df_answers)} companies with answers")
    print(f"  Loaded {len(df_scores)} companies with scores")
    
    conn = get_db_connection()
    cur = conn.cursor()
    
    # Get existing company IDs
    cur.execute("SELECT company_id FROM companies;")
    existing_companies = set(row[0] for row in cur.fetchall())
    
    # Get max IDs to start from (should be 0 after truncate, but good practice)
    try:
        cur.execute("SELECT COALESCE(MAX(response_id), 0) FROM responses;")
        next_response_id = cur.fetchone()[0] + 1
        
        cur.execute("SELECT COALESCE(MAX(item_id), 0) FROM response_items;")
        next_item_id = cur.fetchone()[0] + 1
    except:
        next_response_id = 1
        next_item_id = 1
        
    print(f"  Starting response_id: {next_response_id}")
    print(f"  Starting item_id: {next_item_id}")
    
    responses_added = 0
    response_items_added = 0
    
    print("\nProcessing companies...")
    
    for idx, row in df_answers.iterrows():
        if idx % 50 == 0:
            print(f"  Processing company {idx}/{len(df_answers)}...")
        
        company_id = row['company_id']
        
        if company_id not in existing_companies:
            continue
            
        score_row = df_scores[df_scores['company_id'] == company_id]
        if len(score_row) == 0:
            continue
            
        total_score = score_row.iloc[0]['total_score']
        
        # INSERT RESPONSE
        response_id = next_response_id
        next_response_id += 1
        
        cur.execute("""
            INSERT INTO responses (response_id, company_id, total_score, created_at)
            VALUES (%s, %s, %s, NOW());
        """, (response_id, int(company_id), str(total_score)))
        responses_added += 1
        
        # INSERT ITEMS
        question_cols = [col for col in df_answers.columns if col.startswith('q') and col.endswith('_answer_id')]
        
        for col in question_cols:
            question_id = int(col.split('_')[0][1:])
            answer_ids_str = row[col]
            
            if pd.isna(answer_ids_str):
                continue
            
            # Parse IDs - handle float strings "26.0"
            answer_ids = [int(float(aid)) for aid in str(answer_ids_str).split(',')]
            
            item_id = next_item_id
            next_item_id += 1
            
            cur.execute("""
                INSERT INTO response_items (item_id, response_id, question_id, answers)
                VALUES (%s, %s, %s, %s);
            """, (item_id, response_id, question_id, answer_ids))
            
            response_items_added += 1
            
    conn.commit()
    cur.close()
    conn.close()
    
    print("\n" + "="*80)
    print("DATABASE UPDATE COMPLETE (V4)")
    print("="*80)
    print(f"Responses added: {responses_added}")
    print(f"Response items added: {response_items_added}")

if __name__ == "__main__":
    # clear_existing_data() # We run clean_db.py separately
    insert_data_to_database()
