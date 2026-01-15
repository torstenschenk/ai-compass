import psycopg2
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

cur = conn.cursor()

# Check response_items table constraints
cur.execute("""
    SELECT 
        column_name,
        column_default,
        is_nullable,
        data_type
    FROM information_schema.columns
    WHERE table_name = 'response_items'
    ORDER BY ordinal_position;
""")

print("response_items table columns:")
for row in cur.fetchall():
    print(f"  {row[0]}: {row[3]}, default={row[1]}, nullable={row[2]}")

cur.close()
conn.close()
