import pandas as pd
import psycopg2
from psycopg2 import extras
from dotenv import load_dotenv
import os
import sys

# Ensure output is flushed
sys.stdout.reconfigure(encoding='utf-8')

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

def chunked_list(lst, n):
    for i in range(0, len(lst), n):
        yield lst[i:i + n]

def insert_data_batch_chunked():
    """Insert data using execute_batch with manual chunking and per-chunk commits."""
    
    print("Loading V4 CSV files...")
    df_answers = pd.read_csv('DB_Tables_Raw/assessment_processing/company_answers_with_ids_v4.csv')
    df_scores = pd.read_csv('DB_Tables_Raw/assessment_processing/company_total_scores_v4.csv')
    
    conn = get_db_connection()
    cur = conn.cursor()
    
    # Get existing company IDs
    cur.execute("SELECT company_id FROM companies;")
    existing_companies = set(row[0] for row in cur.fetchall())
    
    # Generate IDs starting from 1 (assuming clear DB)
    next_response_id = 1
    next_item_id = 1
    
    # Prepare data for batch insert
    responses_data = []      # (response_id, company_id, total_score)
    response_items_data = [] # (item_id, response_id, question_id, answers)
    
    print("Preparing data structures...")
    
    question_cols = [col for col in df_answers.columns if col.startswith('q') and col.endswith('_answer_id')]
    
    for idx, row in df_answers.iterrows():
        company_id = row['company_id']
        
        if company_id not in existing_companies:
            continue
            
        score_row = df_scores[df_scores['company_id'] == company_id]
        if len(score_row) == 0:
            continue
            
        total_score = str(score_row.iloc[0]['total_score'])
        response_id = next_response_id
        next_response_id += 1
        
        # Add to responses list
        responses_data.append((response_id, int(company_id), total_score))
        
        # Process items
        for col in question_cols:
            question_id = int(col.split('_')[0][1:])
            answer_ids_str = row[col]
            
            if pd.isna(answer_ids_str):
                continue
                
            # Parse IDs
            answer_ids = [int(float(aid)) for aid in str(answer_ids_str).split(',')]
            
            item_id = next_item_id
            next_item_id += 1
            
            # Add to items list
            response_items_data.append((item_id, response_id, question_id, answer_ids))
            
    print(f"Total to insert: {len(responses_data)} responses, {len(response_items_data)} items.")
    
    # Batch Insert Responses (Small enough to do in one go, usually)
    print("Inserting responses...")
    extras.execute_batch(cur, """
        INSERT INTO responses (response_id, company_id, total_score, created_at)
        VALUES (%s, %s, %s, NOW())
    """, responses_data)
    conn.commit()
    print("Responses committed.")
    
    # Batch Insert Items (Chunked)
    chunk_size = 2000
    print(f"Inserting response items in chunks of {chunk_size}...")
    
    total_chunks = (len(response_items_data) // chunk_size) + 1
    
    for i, chunk in enumerate(chunked_list(response_items_data, chunk_size)):
        print(f"  Inserting chunk {i+1}/{total_chunks}...")
        extras.execute_batch(cur, """
            INSERT INTO response_items (item_id, response_id, question_id, answers)
            VALUES (%s, %s, %s, %s)
        """, chunk)
        conn.commit()
        print(f"  Chunk {i+1} committed.")
    
    cur.close()
    conn.close()
    
    print("BATCH UPLOAD COMPLETE!")

if __name__ == "__main__":
    insert_data_batch_chunked()
