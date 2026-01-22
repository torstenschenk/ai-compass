from sqlalchemy import create_engine, text
import os
from dotenv import load_dotenv

load_dotenv()
db_url = os.getenv("DATABASE_URL")
engine = create_engine(db_url)

with engine.connect() as conn:
    result = conn.execute(text("""
        SELECT c.company_name, c.industry 
        FROM responses r 
        JOIN companies c ON r.company_id = c.company_id 
        WHERE r.response_id = 4
    """))
    row = result.fetchone()
    print(f"Company: {row[0]}, Industry: '{row[1]}'")
