import pandas as pd

print("="*80)
print("OUTPUT FILES VERIFICATION")
print("="*80)

# Load the output files
df_answers = pd.read_csv('company_answers_with_ids.csv')
df_scores = pd.read_csv('company_total_scores.csv')

print(f"\n1. company_answers_with_ids.csv")
print(f"   Rows: {len(df_answers)}")
print(f"   Columns: {len(df_answers.columns)}")
print(f"   Column names: {df_answers.columns.tolist()[:10]}...")

print(f"\n2. company_total_scores.csv")
print(f"   Rows: {len(df_scores)}")
print(f"   Columns: {df_scores.columns.tolist()}")

print("\n" + "="*80)
print("SAMPLE DATA - company_answers_with_ids.csv (first 3 rows, first 10 columns)")
print("="*80)
print(df_answers.iloc[:3, :10].to_string())

print("\n" + "="*80)
print("SAMPLE DATA - company_total_scores.csv (first 10 rows)")
print("="*80)
print(df_scores.head(10).to_string())

print("\n" + "="*80)
print("SCORE STATISTICS")
print("="*80)
print(df_scores['total_score'].describe())

print("\n" + "="*80)
print("DATA QUALITY CHECKS")
print("="*80)

# Check for missing values in scores
missing_scores = df_scores['total_score'].isna().sum()
print(f"\nMissing total scores: {missing_scores}")

# Check score range
min_score = df_scores['total_score'].min()
max_score = df_scores['total_score'].max()
print(f"Score range: {min_score:.2f} to {max_score:.2f}")

# Check for missing answer IDs
total_cells = df_answers.shape[0] * (df_answers.shape[1] - 1)  # Exclude company_id column
missing_cells = df_answers.iloc[:, 1:].isna().sum().sum()
print(f"\nMissing answer IDs: {missing_cells} out of {total_cells} cells ({missing_cells/total_cells*100:.1f}%)")

print("\n" + "="*80)
