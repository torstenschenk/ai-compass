import psycopg2
from psycopg2 import extras
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

def fetch_all_tables():
    """Fetch schema information for all relevant tables."""
    try:
        connection = psycopg2.connect(
            user=USER,
            password=PASSWORD,
            host=HOST,
            port=PORT,
            dbname=DBNAME
        )
        print("Connection successful!\n")
        
        cursor = connection.cursor(cursor_factory=extras.RealDictCursor)
        
        # Get all table names
        cursor.execute("""
            SELECT table_name 
            FROM information_schema.tables 
            WHERE table_schema = 'public'
            ORDER BY table_name;
        """)
        tables = cursor.fetchall()
        
        print("Available tables:")
        for table in tables:
            print(f"  - {table['table_name']}")
        
        print("\n" + "="*80 + "\n")
        
        # For each table, get sample data and structure
        relevant_tables = ['companies', 'questions', 'answers', 'dimensions', 'responses', 'response_items']
        
        for table_name in relevant_tables:
            print(f"\n{'='*80}")
            print(f"TABLE: {table_name}")
            print(f"{'='*80}\n")
            
            # Get column info
            cursor.execute(f"""
                SELECT column_name, data_type, character_maximum_length
                FROM information_schema.columns
                WHERE table_name = '{table_name}'
                ORDER BY ordinal_position;
            """)
            columns = cursor.fetchall()
            
            print("Columns:")
            for col in columns:
                print(f"  - {col['column_name']}: {col['data_type']}")
            
            # Get sample data
            cursor.execute(f"SELECT * FROM {table_name} LIMIT 5;")
            sample_data = cursor.fetchall()
            
            print(f"\nSample data ({len(sample_data)} rows):")
            for i, row in enumerate(sample_data, 1):
                print(f"\nRow {i}:")
                for key, value in row.items():
                    if isinstance(value, str) and len(value) > 100:
                        value = value[:100] + "..."
                    print(f"  {key}: {value}")
        
        cursor.close()
        connection.close()
        print("\nConnection closed.")
        
    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    fetch_all_tables()
