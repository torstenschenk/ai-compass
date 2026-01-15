
import psycopg2
from psycopg2 import extras
import pandas as pd
from dotenv import load_dotenv
import os

# Load environment variables
load_dotenv()

# Database connection parameters
USER = os.getenv("user")
PASSWORD = os.getenv("password")
HOST = os.getenv("host")
PORT = os.getenv("port")
DBNAME = os.getenv("dbname")

def inspect_data():
    try:
        connection = psycopg2.connect(
            user=USER,
            password=PASSWORD,
            host=HOST,
            port=PORT,
            dbname=DBNAME
        )
        cursor = connection.cursor(cursor_factory=extras.RealDictCursor)
        
        # 1. Locate cluster_profile
        print("Checking where 'cluster_profile' column exists...")
        cursor.execute("""
            SELECT table_name 
            FROM information_schema.columns 
            WHERE column_name = 'cluster_profile' AND table_schema = 'public';
        """)
        tables_with_col = cursor.fetchall()
        for t in tables_with_col:
            print(f"Found in table: {t['table_name']}")
            source_table = t['table_name']

        if not tables_with_col:
            print("Column 'cluster_profile' not found in any public table.")
            return

        # 2. Check relationship between source table and 'responses'
        print(f"\nChecking columns in '{source_table}' and 'responses' to find join key...")
        
        cursor.execute(f"SELECT column_name FROM information_schema.columns WHERE table_name = '{source_table}'")
        source_cols = [r['column_name'] for r in cursor.fetchall()]
        print(f"{source_table} columns: {source_cols}")
        
        cursor.execute("SELECT column_name FROM information_schema.columns WHERE table_name = 'responses'")
        dest_cols = [r['column_name'] for r in cursor.fetchall()]
        print(f"responses columns: {dest_cols}")
        
        # 3. Sample header data from cluster_profile
        print(f"\nSampling 'cluster_profile' data from {source_table}...")
        cursor.execute(f"SELECT cluster_profile FROM {source_table} LIMIT 5;")
        samples = cursor.fetchall()
        for s in samples:
            print(f"Sample: '{s['cluster_profile']}'")

        cursor.close()
        connection.close()
        
    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    inspect_data()
