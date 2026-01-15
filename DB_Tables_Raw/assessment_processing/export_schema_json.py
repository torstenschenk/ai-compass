import psycopg2
from psycopg2 import extras
from dotenv import load_dotenv
import os
import json

load_dotenv()

conn = psycopg2.connect(
    user=os.getenv("user"),
    password=os.getenv("password"),
    host=os.getenv("host"),
    port=os.getenv("port"),
    dbname=os.getenv("dbname")
)

cur = conn.cursor(cursor_factory=extras.RealDictCursor)

tables = ['companies', 'questions', 'answers', 'dimensions', 'responses', 'response_items']

output = {}

for table in tables:
    print(f"\nFetching {table}...")
    
    # Get columns
    cur.execute(f"""
        SELECT column_name, data_type 
        FROM information_schema.columns 
        WHERE table_name = '{table}' 
        ORDER BY ordinal_position;
    """)
    columns = cur.fetchall()
    
    # Get sample data
    cur.execute(f"SELECT * FROM {table} LIMIT 3;")
    rows = cur.fetchall()
    
    output[table] = {
        'columns': columns,
        'sample_data': rows
    }

# Save to JSON
with open('db_schema.json', 'w', encoding='utf-8') as f:
    json.dump(output, f, indent=2, default=str)

print("\nSaved to db_schema.json")

cur.close()
conn.close()
