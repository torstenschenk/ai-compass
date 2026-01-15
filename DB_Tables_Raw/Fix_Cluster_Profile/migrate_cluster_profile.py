
import psycopg2
from psycopg2 import extras
import re
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

def migrate():
    try:
        connection = psycopg2.connect(
            user=USER,
            password=PASSWORD,
            host=HOST,
            port=PORT,
            dbname=DBNAME
        )
        connection.autocommit = False # Use transactions
        cursor = connection.cursor(cursor_factory=extras.RealDictCursor)

        print("--- Starting Migration ---")

        # 1. Add column to responses
        print("\nAdding 'cluster_profile' (INTEGER) to 'responses'...")
        try:
            cursor.execute("ALTER TABLE responses ADD COLUMN IF NOT EXISTS cluster_profile INTEGER;")
        except Exception as e:
            print(f"Column might already exist or error: {e}")
            connection.rollback()
            return

        # 2. Fetch source data from companies (using company_id)
        print("\nFetching source data from 'companies'...")
        cursor.execute("SELECT company_id, cluster_profile FROM companies WHERE cluster_profile IS NOT NULL;")
        companies = cursor.fetchall()
        print(f"Found {len(companies)} companies with profile data.")

        # 3. Migrate and Clean
        print("\nMigrating data...")
        updated_count = 0
        for comp in companies:
            comp_id = comp['company_id']
            raw_profile = comp['cluster_profile']
            
            # Extract number
            match = re.match(r"(\d+)", str(raw_profile))
            if match:
                clean_profile = int(match.group(1))
                
                # Update responses where company_id matches
                query = "UPDATE responses SET cluster_profile = %s WHERE company_id = %s;"
                cursor.execute(query, (clean_profile, comp_id))
                updated_count += cursor.rowcount
            else:
                print(f"Skipping invalid format: '{raw_profile}' (Company ID: {comp_id})")

        print(f"Updated (approx rows affected) in 'responses'. logic is one-to-many so this might be > company count.")

        # 4. Verify
        print("\nVerifying migration...")
        cursor.execute("SELECT COUNT(*) as count FROM responses WHERE cluster_profile IS NOT NULL;")
        new_count = cursor.fetchone()['count']
        print(f"Responses with cluster_profile: {new_count}")
        
        cursor.execute("SELECT cluster_profile FROM responses WHERE cluster_profile IS NOT NULL LIMIT 5;")
        samples = cursor.fetchall()
        print("Sample data in responses:", [s['cluster_profile'] for s in samples])

        if new_count == 0 and len(companies) > 0:
             print("WARNING: No data migrated! Rolling back.")
             connection.rollback()
             return

        # 5. Drop old column
        print("\nDropping old column 'cluster_profile' from 'companies'...")
        cursor.execute("ALTER TABLE companies DROP COLUMN cluster_profile;")
        print("Column dropped.")

        connection.commit()
        print("\n--- Migration Complete Successfully ---")

        cursor.close()
        connection.close()

    except Exception as e:
        print(f"\nCRITICAL ERROR: {e}")
        if connection:
            connection.rollback()
            print("Transaction rolled back.")

if __name__ == "__main__":
    migrate()
