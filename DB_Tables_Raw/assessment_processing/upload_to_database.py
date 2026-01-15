import pandas as pd
import psycopg2
from psycopg2 import extras
from dotenv import load_dotenv
import os

load_dotenv()

def get_db_connection():
    return psycopg2.connect(
        user=os.getenv("user"),
        password=os.getenv("password"),
        host=os.getenv("host"),
        port=os.getenv("port"),
        dbname=os.getenv("dbname")
    )

def check_table_structure():
    """Check current structure of response_items table."""
    conn = get_db_connection()
    cur = conn.cursor(cursor_factory=extras.RealDictCursor)
    
    cur.execute("""
        SELECT column_name, data_type 
        FROM information_schema.columns 
        WHERE table_name = 'response_items' 
        ORDER BY ordinal_position;
    """)
    
    columns = cur.fetchall()
    print("Current response_items table structure:")
    for col in columns:
        print(f"  - {col['column_name']}: {col['data_type']}")
    
    cur.close()
    conn.close()
    
    return columns

def update_response_items_schema():
    """Update response_items table to use INTEGER[] for answers."""
    conn = get_db_connection()
    cur = conn.cursor()
    
    print("\nUpdating response_items table schema...")
    
    # Check if answers column is already INTEGER[]
    cur.execute("""
        SELECT data_type 
        FROM information_schema.columns 
        WHERE table_name = 'response_items' AND column_name = 'answers';
    """)
    
    result = cur.fetchone()
    
    if result and result[0] == 'ARRAY':
        print("  answers column is already INTEGER[] - no change needed")
    elif result and result[0] == 'text':
        print("  Converting answers column from TEXT to INTEGER[]...")
        cur.execute("""
            ALTER TABLE response_items 
            ALTER COLUMN answers TYPE INTEGER[] 
            USING string_to_array(answers, ',')::INTEGER[];
        """)
        conn.commit()
        print("  Conversion complete!")
    else:
        print(f"  Current type: {result[0] if result else 'unknown'}")
        print("  Altering to INTEGER[]...")
        cur.execute("""
            ALTER TABLE response_items 
            ALTER COLUMN answers TYPE INTEGER[] 
            USING CASE 
                WHEN answers IS NULL THEN NULL 
                ELSE string_to_array(answers, ',')::INTEGER[] 
            END;
        """)
        conn.commit()
        print("  Conversion complete!")
    
    cur.close()
    conn.close()

def insert_data_to_database():
    """Insert data from CSV files into database tables."""
    
    # Load CSV files
    print("\nLoading CSV files...")
    df_answers = pd.read_csv('DB_Tables_Raw/assessment_processing/company_answers_with_ids_v2.csv')
    df_scores = pd.read_csv('DB_Tables_Raw/assessment_processing/company_total_scores_v2.csv')
    
    print(f"  Loaded {len(df_answers)} companies with answers")
    print(f"  Loaded {len(df_scores)} companies with scores")
    
    conn = get_db_connection()
    cur = conn.cursor()
    
    # Get existing company IDs
    cur.execute("SELECT company_id FROM companies;")
    existing_companies = set(row[0] for row in cur.fetchall())
    
    print(f"\n  Found {len(existing_companies)} existing companies in database")
    
    # Get max response_id to start from
    cur.execute("SELECT COALESCE(MAX(response_id), 0) as max_id FROM responses;")
    max_response_id = cur.fetchone()[0]
    next_response_id = max_response_id + 1
    
    # Get max item_id to start from
    cur.execute("SELECT COALESCE(MAX(item_id), 0) as max_id FROM response_items;")
    max_item_id = cur.fetchone()[0]
    next_item_id = max_item_id + 1
    
    print(f"  Starting response_id from: {next_response_id}")
    print(f"  Starting item_id from: {next_item_id}")
    
    # Track statistics
    companies_added = 0
    responses_added = 0
    response_items_added = 0
    
    print("\nProcessing companies...")
    
    for idx, row in df_answers.iterrows():
        if idx % 100 == 0:
            print(f"  Processing company {idx}/{len(df_answers)}...")
        
        company_id = row['company_id']
        
        # Skip if company doesn't exist in companies table
        if company_id not in existing_companies:
            print(f"  Warning: Company {company_id} not in companies table, skipping...")
            continue
        
        # Get total score for this company
        score_row = df_scores[df_scores['company_id'] == company_id]
        if len(score_row) == 0:
            print(f"  Warning: No score found for company {company_id}, skipping...")
            continue
        
        total_score = score_row.iloc[0]['total_score']
        
        # Insert into responses table (total_score is VARCHAR in database)
        # response_id must be provided explicitly (no auto-increment)
        response_id = next_response_id
        next_response_id += 1
        
        cur.execute("""
            INSERT INTO responses (response_id, company_id, total_score, created_at)
            VALUES (%s, %s, %s, NOW());
        """, (response_id, int(company_id), str(total_score)))
        responses_added += 1
        
        # Insert response items
        question_cols = [col for col in df_answers.columns if col.startswith('q') and col.endswith('_answer_id')]
        
        for col in question_cols:
            # Extract question_id from column name (e.g., "q5_answer_id" -> 5)
            question_id = int(col.split('_')[0][1:])
            
            # Get answer IDs
            answer_ids_str = row[col]
            
            if pd.isna(answer_ids_str):
                continue
            
            # Parse answer IDs (comma-separated string to array)
            # Handle float strings like "26.0" by converting to float first, then int
            answer_ids = [int(float(aid)) for aid in str(answer_ids_str).split(',')]
            
            # Insert into response_items with PostgreSQL array
            # item_id must be provided explicitly (no auto-increment)
            item_id = next_item_id
            next_item_id += 1
            
            cur.execute("""
                INSERT INTO response_items (item_id, response_id, question_id, answers)
                VALUES (%s, %s, %s, %s);
            """, (item_id, response_id, question_id, answer_ids))
            
            response_items_added += 1
    
    # Commit all changes
    conn.commit()
    
    print("\n" + "="*80)
    print("DATABASE UPDATE SUMMARY")
    print("="*80)
    print(f"Responses added: {responses_added}")
    print(f"Response items added: {response_items_added}")
    print(f"\nAll changes committed successfully!")
    
    cur.close()
    conn.close()

def verify_data():
    """Verify the inserted data."""
    conn = get_db_connection()
    cur = conn.cursor(cursor_factory=extras.RealDictCursor)
    
    print("\n" + "="*80)
    print("VERIFICATION")
    print("="*80)
    
    # Count records
    cur.execute("SELECT COUNT(*) as count FROM responses;")
    responses_count = cur.fetchone()['count']
    
    cur.execute("SELECT COUNT(*) as count FROM response_items;")
    items_count = cur.fetchone()['count']
    
    print(f"\nTotal responses in database: {responses_count}")
    print(f"Total response_items in database: {items_count}")
    
    # Show sample data
    print("\nSample responses (first 5):")
    cur.execute("SELECT * FROM responses ORDER BY response_id LIMIT 5;")
    for row in cur.fetchall():
        print(f"  Response {row['response_id']}: Company {row['company_id']}, Score {row['total_score']}")
    
    print("\nSample response_items (first 5):")
    cur.execute("SELECT * FROM response_items ORDER BY item_id LIMIT 5;")
    for row in cur.fetchall():
        print(f"  Item {row['item_id']}: Response {row['response_id']}, Question {row['question_id']}, Answers {row['answers']}")
    
    cur.close()
    conn.close()

def main():
    print("="*80)
    print("UPLOAD DATA TO DATABASE")
    print("="*80)
    
    # Step 1: Check current table structure
    print("\n1. Checking table structure...")
    check_table_structure()
    
    # Step 2: Update schema if needed
    print("\n2. Updating schema...")
    update_response_items_schema()
    
    # Step 3: Insert data
    print("\n3. Inserting data...")
    insert_data_to_database()
    
    # Step 4: Verify
    print("\n4. Verifying data...")
    verify_data()
    
    print("\n" + "="*80)
    print("UPLOAD COMPLETE!")
    print("="*80)

if __name__ == "__main__":
    main()
