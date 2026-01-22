import pandas as pd
from sqlalchemy import create_engine, inspect
import os
from dotenv import load_dotenv

def export_to_csv():
    # Load environment variables
    load_dotenv()
    
    # Get DB URL from .env
    db_url = os.getenv("DATABASE_URL")
    if not db_url:
        print("DATABASE_URL not found in .env")
        return

    # Path to save CSVs
    output_path = "/Users/christianmiething/Downloads/ai-compass/MVP_Chris"
    
    try:
        # Create a synchronous engine for the export
        # (Standard postgresql:// works with psycopg2 which is in requirements)
        engine = create_engine(db_url)
        inspector = inspect(engine)
        
        # Get all table names
        tables = inspector.get_table_names()
        print(f"Found tables: {tables}")
        
        for table in tables:
            print(f"Exporting {table}...")
            # Query the table using pandas
            df = pd.read_sql_table(table, engine)
            
            # Save to CSV
            csv_filename = os.path.join(output_path, f"{table}.csv")
            df.to_csv(csv_filename, index=False)
            print(f"Successfully saved {csv_filename}")
            
    except Exception as e:
        print(f"An error occurred: {e}")

if __name__ == "__main__":
    export_to_csv()
