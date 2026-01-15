import pandas as pd

# Load old scores (v2 - missing questions)
try:
    df_old = pd.read_csv('DB_Tables_Raw/assessment_processing/company_total_scores_v2.csv')
except:
    # Fallback if v2 doesn't exist, try original
    df_old = pd.read_csv('company_total_scores.csv')

# Load new scores (v4 - complete data)
df_new = pd.read_csv('DB_Tables_Raw/assessment_processing/company_total_scores_v4.csv')

# Merge
df_comparison = pd.merge(df_old, df_new, on='company_id', suffixes=('_old', '_new'))

# Calculate difference
df_comparison['diff'] = df_comparison['total_score_new'] - df_comparison['total_score_old']

print(f"Old Scores (Mean): {df_comparison['total_score_old'].mean():.4f}")
print(f"New Scores (Mean): {df_comparison['total_score_new'].mean():.4f}")
print(f"Average Increase: {df_comparison['diff'].mean():.4f}")
print(f"Max Increase: {df_comparison['diff'].max():.4f}")

# Show count of changed scores
changed = df_comparison[abs(df_comparison['diff']) > 0.0001]
print(f"\nCompanies with changed scores: {len(changed)} / {len(df_comparison)}")

print("\nSample changes:")
print(changed[['company_id', 'total_score_old', 'total_score_new', 'diff']].head())
