
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

def analyze_database():
    try:
        connection = psycopg2.connect(
            user=USER,
            password=PASSWORD,
            host=HOST,
            port=PORT,
            dbname=DBNAME
        )
        print("✓ Connection successful!")
        
        cursor = connection.cursor(cursor_factory=extras.RealDictCursor)
        
        # Get all tables in public schema
        query_tables = """
            SELECT table_name 
            FROM information_schema.tables 
            WHERE table_schema = 'public';
        """
        cursor.execute(query_tables)
        tables = cursor.fetchall()
        
        print(f"\nFound {len(tables)} tables:")
        print("=" * 40)
        
        for table in tables:
            table_name = table['table_name']
            print(f"\nTable: {table_name}")
            print("-" * 20)
            
            # Get columns for this table
            query_columns = f"""
                SELECT column_name, data_type, is_nullable
                FROM information_schema.columns 
                WHERE table_name = '{table_name}';
            """
            cursor.execute(query_columns)
            columns = cursor.fetchall()
            
            df = pd.DataFrame(columns)
            if not df.empty:
                 print(df.to_string(index=False))
            else:
                 print("No columns found (empty?)")
            
            # Get row count
            try:
                cursor.execute(f"SELECT COUNT(*) FROM {table_name};")
                count = cursor.fetchone()['count']
                print(f"\nRow count: {count}")
            except Exception as e:
                print(f"Could not get row count: {e}")

        cursor.close()
        connection.close()
        
    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    analyze_database()
