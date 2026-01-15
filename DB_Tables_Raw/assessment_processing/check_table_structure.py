import psycopg2
from psycopg2 import extras
from dotenv import load_dotenv
import os

load_dotenv()

conn = psycopg2.connect(
    user=os.getenv("user"),
    password=os.getenv("password"),
    host=os.getenv("host"),
    port=os.getenv("port"),
    dbname=os.getenv("dbname")
)

cur = conn.cursor(cursor_factory=extras.RealDictCursor)

# Check responses table structure
cur.execute("""
    SELECT column_name, data_type, character_maximum_length
    FROM information_schema.columns
    WHERE table_name = 'responses'
    ORDER BY ordinal_position;
""")

print("responses table structure:")
for col in cur.fetchall():
    print(f"  {col['column_name']}: {col['data_type']}")

# Check response_items table structure
cur.execute("""
    SELECT column_name, data_type
    FROM information_schema.columns
    WHERE table_name = 'response_items'
    ORDER BY ordinal_position;
""")

print("\nresponse_items table structure:")
for col in cur.fetchall():
    print(f"  {col['column_name']}: {col['data_type']}")

cur.close()
conn.close()
