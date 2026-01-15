import pandas as pd
import psycopg2
from psycopg2 import extras
from dotenv import load_dotenv
import os
import sys

# Load environment variables
load_dotenv()

def get_db_connection():
    return psycopg2.connect(
        user=os.getenv("user"),
        password=os.getenv("password"),
        host=os.getenv("host"),
        port=os.getenv("port"),
        dbname=os.getenv("dbname")
    )

def fetch_all_data():
    """
    Fetch data from all relevant tables and return as a dictionary of DataFrames.
    Tables: companies, responses, response_items, questions, answers, dimensions
    """
    conn = get_db_connection()
    data = {}
    
    try:
        print("Fetching data from database...")
        
        # 1. Companies
        query_companies = "SELECT * FROM companies;"
        data['companies'] = pd.read_sql(query_companies, conn)
        print(f"  Companies: {len(data['companies'])} rows")
        
        # 2. Responses (Scores)
        query_responses = "SELECT * FROM responses;"
        data['responses'] = pd.read_sql(query_responses, conn)
        # Convert total_score to numeric, coercing errors
        data['responses']['total_score'] = pd.to_numeric(data['responses']['total_score'], errors='coerce')
        print(f"  Responses: {len(data['responses'])} rows")
        
        # 3. Questions
        query_questions = "SELECT * FROM questions ORDER BY question_id;"
        data['questions'] = pd.read_sql(query_questions, conn)
        print(f"  Questions: {len(data['questions'])} rows")
        
        # 4. Answers (Metadata)
        query_answers = "SELECT * FROM answers ORDER BY answer_id;"
        data['answers'] = pd.read_sql(query_answers, conn)
        print(f"  Answers (Metadata): {len(data['answers'])} rows")
        
        # 5. Dimensions
        query_dimensions = "SELECT * FROM dimensions;"
        data['dimensions'] = pd.read_sql(query_dimensions, conn)
        print(f"  Dimensions: {len(data['dimensions'])} rows")
        
        # 6. Response Items (Detailed Answers) - LIMIT columns for performance if needed
        # Fetching everything for 16,500 rows is fine
        query_items = "SELECT * FROM response_items;"
        data['response_items'] = pd.read_sql(query_items, conn)
        print(f"  Response Items: {len(data['response_items'])} rows")
        
    except Exception as e:
        print(f"Error fetching data: {e}")
        sys.exit(1)
    finally:
        conn.close()
        
    return data

if __name__ == "__main__":
    # Test execution
    data = fetch_all_data()
    print("Data fetch successful.")
