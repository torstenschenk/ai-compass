import pandas as pd

# Load both CSVs
df_original = pd.read_csv('AI_Compass_data_generation_2/assessment_data.csv')
df_v2 = pd.read_csv('DB_Tables_Raw/assessment_processing/company_answers_with_ids_v2.csv')

# Get first company
company_id = df_v2.iloc[0]['company_id']

print(f"Checking company {company_id} (response_id 1)")
print("="*80)

# Missing question IDs
missing_qids = [13, 16, 18, 24, 26, 28, 30, 31]

print("\nChecking original CSV vs v2 CSV for missing questions:")
print("-"*80)

for qid in missing_qids:
    # Find question in original CSV
    col_in_v2 = f"q{qid}_answer_id"
    
    # Check if column exists in v2
    if col_in_v2 in df_v2.columns:
        v2_value = df_v2.iloc[0][col_in_v2]
        print(f"\nQuestion {qid}:")
        print(f"  In v2 CSV (answer_id): {v2_value}")
        print(f"  Is NaN: {pd.isna(v2_value)}")
    else:
        print(f"\nQuestion {qid}: Column {col_in_v2} NOT FOUND in v2 CSV!")

print("\n" + "="*80)
print("Checking all question columns in v2 CSV:")
print("-"*80)

question_cols = [col for col in df_v2.columns if col.startswith('q') and col.endswith('_answer_id')]
question_ids = sorted([int(col.split('_')[0][1:]) for col in question_cols])

print(f"Question IDs present in v2 CSV: {question_ids}")
print(f"Total: {len(question_ids)} questions")

# Check which are missing
all_expected = list(range(1, 34))  # Assuming 33 questions
missing_from_csv = [q for q in all_expected if q not in question_ids]

if missing_from_csv:
    print(f"\nQuestions missing from v2 CSV columns: {missing_from_csv}")
else:
    print("\nAll expected question columns present in v2 CSV")
