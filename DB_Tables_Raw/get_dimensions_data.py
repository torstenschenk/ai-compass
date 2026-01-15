import psycopg2
from psycopg2 import extras
import pandas as pd
from dotenv import load_dotenv
import os

# Load environment variables from .env file
load_dotenv()

# Database connection parameters from environment variables
USER = os.getenv("user")
PASSWORD = os.getenv("password")
HOST = os.getenv("host")
PORT = os.getenv("port")
DBNAME = os.getenv("dbname")

def connect_and_fetch_dimensions():
    """Connect to the database and fetch all data from the dimensions table."""
    try:
        # Establish connection
        connection = psycopg2.connect(
            user=USER,
            password=PASSWORD,
            host=HOST,
            port=PORT,
            dbname=DBNAME
        )
        print("✓ Connection successful!")
        
        # Create a cursor
        cursor = connection.cursor(cursor_factory=extras.RealDictCursor)
        
        # Query the dimensions table
        query = "SELECT * FROM dimensions;"
        cursor.execute(query)
        
        # Fetch all results
        results = cursor.fetchall()
        
        print(f"\n✓ Retrieved {len(results)} rows from dimensions table\n")
        print("=" * 80)
        
        # Display the data
        if results:
            # Convert to pandas DataFrame for better display
            df = pd.DataFrame(results)
            output = df.to_string()
            print(output)
            
            # Save to file
            with open("dimensions_table_output.txt", "w", encoding="utf-8") as f:
                f.write(f"Dimensions Table Data\n")
                f.write(f"Retrieved: {len(results)} rows\n")
                f.write("=" * 80 + "\n\n")
                f.write(output)
                f.write("\n\n" + "=" * 80)
            print("\n✓ Data saved to dimensions_table_output.txt")
        else:
            print("No data found in dimensions table.")
        
        print("=" * 80)
        
        # Close cursor and connection
        cursor.close()
        connection.close()
        print("\n✓ Connection closed.")
        
        return results
        
    except Exception as e:
        print(f"✗ Failed to connect or fetch data: {e}")
        return None

if __name__ == "__main__":
    data = connect_and_fetch_dimensions()

# -------------------------
# SQLAlchemy
# -------------------------
# from dotenv import load_dotenv
# import os

# load_dotenv()
# DATABASE_URL = os.getenv("DATABASE_URL")

# # Then use it with SQLAlchemy:
# from sqlalchemy import create_engine
# engine = create_engine(DATABASE_URL)