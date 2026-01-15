import pandas as pd

# Load both versions
df_old = pd.read_csv('DB_Tables_Raw/assessment_processing/company_answers_with_ids.csv')
df_new = pd.read_csv('DB_Tables_Raw/assessment_processing/company_answers_with_ids_v2.csv')

df_scores_old = pd.read_csv('DB_Tables_Raw/assessment_processing/company_total_scores.csv')
df_scores_new = pd.read_csv('DB_Tables_Raw/assessment_processing/company_total_scores_v2.csv')

print("="*80)
print("COMPARISON: OLD vs NEW OUTPUT")
print("="*80)

print("\n1. ANSWER IDS FILE")
print("-"*80)
print(f"Old version: {df_old.shape[0]} rows, {df_old.shape[1]} columns")
print(f"New version: {df_new.shape[0]} rows, {df_new.shape[1]} columns")

# Count missing values
old_missing = df_old.iloc[:, 1:].isna().sum().sum()
new_missing = df_new.iloc[:, 1:].isna().sum().sum()

old_total = df_old.shape[0] * (df_old.shape[1] - 1)
new_total = df_new.shape[0] * (df_new.shape[1] - 1)

print(f"\nOld version missing answers: {old_missing}/{old_total} ({old_missing/old_total*100:.1f}%)")
print(f"New version missing answers: {new_missing}/{new_total} ({new_missing/new_total*100:.1f}%)")
print(f"Improvement: {old_missing - new_missing} fewer missing answers")

print("\n2. TOTAL SCORES FILE")
print("-"*80)
print(f"Old scores - Mean: {df_scores_old['total_score'].mean():.4f}, Range: {df_scores_old['total_score'].min():.4f} to {df_scores_old['total_score'].max():.4f}")
print(f"New scores - Mean: {df_scores_new['total_score'].mean():.4f}, Range: {df_scores_new['total_score'].min():.4f} to {df_scores_new['total_score'].max():.4f}")

# Check specific companies
print("\n3. SAMPLE COMPARISON (First 3 companies)")
print("-"*80)

for i in range(3):
    company_id = df_old.iloc[i, 0]
    old_score = df_scores_old.iloc[i]['total_score']
    new_score = df_scores_new.iloc[i]['total_score']
    
    # Count non-null answers
    old_answers = df_old.iloc[i, 1:].notna().sum()
    new_answers = df_new.iloc[i, 1:].notna().sum()
    
    print(f"\nCompany {company_id}:")
    print(f"  Old: {old_answers} answers, score = {old_score:.4f}")
    print(f"  New: {new_answers} answers, score = {new_score:.4f}")
    print(f"  Difference: +{new_answers - old_answers} answers, score change = {new_score - old_score:.4f}")

print("\n" + "="*80)
print("CONCLUSION")
print("="*80)

if new_missing < old_missing:
    print(f"✓ IMPROVED: {old_missing - new_missing} more answers successfully mapped!")
elif new_missing == old_missing:
    print("= SAME: No change in missing answers")
else:
    print(f"✗ WORSE: {new_missing - old_missing} more answers missing")

if new_missing == 0:
    print("✓ PERFECT: All answers mapped successfully!")
