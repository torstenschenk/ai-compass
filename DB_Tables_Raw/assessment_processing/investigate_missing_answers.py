import pandas as pd

# Load both CSVs
df_original = pd.read_csv('AI_Compass_data_generation_2/assessment_data.csv')
df_output = pd.read_csv('DB_Tables_Raw/assessment_processing/company_answers_with_ids.csv')

print("="*80)
print("INVESTIGATING MISSING ANSWERS")
print("="*80)

# Check first company
print("\nFirst company (row 0):")
print(f"Company ID: {df_original.iloc[0, 0]}")

# Get question columns (starting at column 7)
question_cols = df_original.columns[7:].tolist()

print(f"\nTotal question columns: {len(question_cols)}")

# Check for missing values in original
missing_in_original = 0
for i, col in enumerate(question_cols):
    val = df_original.iloc[0, 7 + i]
    if pd.isna(val):
        missing_in_original += 1
        print(f"  Q{i+1}: MISSING in original")

print(f"\nMissing in original CSV: {missing_in_original}")

# Check for missing values in output
missing_in_output = 0
output_cols = [col for col in df_output.columns if col.startswith('q')]
print(f"\nOutput has {len(output_cols)} question columns")

for col in output_cols:
    val = df_output.iloc[0][col]
    if pd.isna(val):
        missing_in_output += 1

print(f"Missing in output CSV: {missing_in_output}")

# Find a checklist question and examine it
print("\n" + "="*80)
print("EXAMINING CHECKLIST QUESTION ANSWERS")
print("="*80)

# Look at a few sample answers from original CSV
for i in range(min(5, len(question_cols))):
    answer = df_original.iloc[0, 7 + i]
    question = question_cols[i]
    
    print(f"\nQ{i+1}:")
    print(f"  Question: {question[:80]}...")
    print(f"  Answer: {answer}")
    
    # Check if answer contains commas
    if isinstance(answer, str) and ',' in answer:
        print(f"  ⚠ Contains comma! Possible checklist answer")
        print(f"  Parts if split by comma: {answer.split(',')}")
