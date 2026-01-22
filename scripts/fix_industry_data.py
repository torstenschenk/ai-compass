from sqlalchemy import create_engine, text
import os
from dotenv import load_dotenv

load_dotenv()
db_url = os.getenv("DATABASE_URL")
engine = create_engine(db_url)

with engine.connect() as conn:
    print("Updating industry to Manufacturing for response 4's company...")
    # Get company_id for response 4
    result = conn.execute(text("SELECT company_id FROM responses WHERE response_id = 4"))
    company_id = result.scalar()
    
    if company_id:
        conn.execute(text("UPDATE companies SET industry = 'Manufacturing' WHERE company_id = :cid"), {"cid": company_id})
        conn.commit()
        print(f"Updated Company ID {company_id} to 'Manufacturing'.")
    else:
        print("Response 4 not found.")
