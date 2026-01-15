import pandas as pd
import psycopg2
from psycopg2 import extras
from dotenv import load_dotenv
import os
import sys

# Configure UTF-8 output for file writing
sys.stdout.reconfigure(encoding='utf-8')

load_dotenv()

# Load CSV
df = pd.read_csv('AI_Compass_data_generation_2/assessment_data.csv')

# Connect to DB
conn = psycopg2.connect(
    user=os.getenv("user"),
    password=os.getenv("password"),
    host=os.getenv("host"),
    port=os.getenv("port"),
    dbname=os.getenv("dbname")
)
cur = conn.cursor(cursor_factory=extras.RealDictCursor)

# Get questions
cur.execute("SELECT * FROM questions ORDER BY question_id;")
questions = cur.fetchall()

# Missing question IDs
missing_qids = [13, 18, 28, 30]

with open('DB_Tables_Raw/assessment_processing/detailed_mismatch_analysis.txt', 'w', encoding='utf-8') as f:
    f.write("="*80 + "\n")
    f.write("DETAILED MISMATCH ANALYSIS FOR 4 MISSING QUESTIONS\n")
    f.write("="*80 + "\n\n")

    for qid in missing_qids:
        question_obj = questions[qid - 1]  # 0-indexed
        
        f.write(f"\n{'='*80}\n")
        f.write(f"QUESTION {qid}\n")
        f.write(f"{'='*80}\n")
        f.write(f"Question Text (DB): {question_obj['question_text']}\n")
        f.write(f"Type: {question_obj['type']}\n\n")
        
        # Get answers from DB
        cur.execute(f"SELECT * FROM answers WHERE question_id = {qid};")
        db_answers = cur.fetchall()
        
        f.write(f"--- DATABASE ANSWERS ({len(db_answers)}) ---\n")
        for ans in db_answers:
            f.write(f"ID {ans['answer_id']}: '{ans['answer_text']}'\n")
        
        # Get CSV column (position-based)
        csv_col_idx = qid - 1  # Questions start at index 0 in CSV question columns
        csv_column = df.columns[7 + csv_col_idx]
        
        f.write(f"\n--- CSV COLUMN ---\n")
        f.write(f"Name: {csv_column}\n\n")
        
        # Get unique answers from CSV for this column
        unique_csv_answers = df.iloc[:, 7 + csv_col_idx].unique()
        f.write(f"--- UNIQUE CSV ANSWERS ({len(unique_csv_answers)}) ---\n")
        for ans in unique_csv_answers:
            if pd.isna(ans):
                f.write("Expected <NaN>\n")
            else:
                f.write(f"'{ans}'\n")
                
                # Check for near matches
                f.write("  Mismatch Analysis:\n")
                found_match = False
                for db_ans in db_answers:
                    # Simple check
                    if ans == db_ans['answer_text']:
                        f.write(f"    -> EXACT MATCH FOUND with ID {db_ans['answer_id']}\n")
                        found_match = True
                        break
                    
                    # Normalize check (lower, strip)
                    if str(ans).strip().lower() == str(db_ans['answer_text']).strip().lower():
                         f.write(f"    -> NORMALIZED MATCH FOUND with ID {db_ans['answer_id']} (only case/whitespace diff)\n")
                         
                if not found_match:
                     f.write(f"    -> NO MATCH FOUND. Closest DB options:\n")
                     # Show first 3 chars match?
                     for db_ans in db_answers:
                         if str(ans)[:10] == str(db_ans['answer_text'])[:10]:
                             f.write(f"       Starts same as ID {db_ans['answer_id']}: '{db_ans['answer_text'][:20]}...'\n")

cur.close()
conn.close()
print("Analysis complete. Check DB_Tables_Raw/assessment_processing/detailed_mismatch_analysis.txt")
