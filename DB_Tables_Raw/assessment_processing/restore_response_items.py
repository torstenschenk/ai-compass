import pandas as pd
import psycopg2
from psycopg2 import extras
from dotenv import load_dotenv
import os
import sys
from pathlib import Path

# Ensure output is flushed
sys.stdout.reconfigure(encoding='utf-8')

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

def chunked_list(lst, n):
    for i in range(0, len(lst), n):
        yield lst[i:i + n]

def restore_items():
    print("Connecting to database...")
    conn = get_db_connection()
    cur = conn.cursor()
    
    # 1. Fetch Company ID -> Response ID map
    print("Fetching existing response IDs...")
    cur.execute("SELECT company_id, response_id FROM responses;")
    responses_map = {row[0]: row[1] for row in cur.fetchall()}
    print(f"Found {len(responses_map)} existing responses.")
    
    if len(responses_map) == 0:
        print("Error: No responses found. Cannot restore items without responses.")
        return

    # 2. Start ITEM ID from max+1 (or 1 if empty)
    cur.execute("SELECT COALESCE(MAX(item_id), 0) FROM response_items;")
    next_item_id = cur.fetchone()[0] + 1
    print(f"Starting item_id: {next_item_id}")

    # 3. Load CSV
    print("Loading V4 answers CSV...")
    df_answers = pd.read_csv('DB_Tables_Raw/assessment_processing/company_answers_with_ids_v4.csv')
    
    response_items_data = [] # (item_id, response_id, question_id, answers)
    question_cols = [col for col in df_answers.columns if col.startswith('q') and col.endswith('_answer_id')]
    
    print("Preparing items for restoration...")
    skipped_companies = 0
    
    for idx, row in df_answers.iterrows():
        company_id = row['company_id']
        
        if company_id not in responses_map:
            skipped_companies += 1
            continue
            
        response_id = responses_map[company_id]
        
        for col in question_cols:
            question_id = int(col.split('_')[0][1:])
            answer_ids_str = row[col]
            
            if pd.isna(answer_ids_str):
                continue
                
            # Parse IDs
            answer_ids = [int(float(aid)) for aid in str(answer_ids_str).split(',')]
            
            item_id = next_item_id
            next_item_id += 1
            
            response_items_data.append((item_id, response_id, question_id, answer_ids))
            
    print(f"Prepared {len(response_items_data)} items.")
    if skipped_companies > 0:
        print(f"Warning: {skipped_companies} companies in CSV had no matching response in DB.")
        
    # 4. Batch Insert Items (Chunked)
    chunk_size = 2000
    print(f"Inserting response items in chunks of {chunk_size}...")
    
    total_chunks = (len(response_items_data) // chunk_size) + 1 if len(response_items_data) > 0 else 0
    
    for i, chunk in enumerate(chunked_list(response_items_data, chunk_size)):
        print(f"  Inserting chunk {i+1}/{total_chunks}...")
        extras.execute_batch(cur, """
            INSERT INTO response_items (item_id, response_id, question_id, answers)
            VALUES (%s, %s, %s, %s)
        """, chunk)
        conn.commit()
    
    cur.close()
    conn.close()
    print("RESTORATION COMPLETE!")

if __name__ == "__main__":
    restore_items()
