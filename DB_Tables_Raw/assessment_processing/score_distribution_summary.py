import pandas as pd

# Load scores
df_scores = pd.read_csv('DB_Tables_Raw/assessment_processing/company_total_scores.csv')

print("="*80)
print("SCORE DISTRIBUTION SUMMARY")
print("="*80)

print("\nStatistics:")
print(df_scores['total_score'].describe())

print("\n" + "="*80)
print("Score Ranges:")
print("="*80)

# Create score ranges
bins = [0, 1, 2, 3, 4, 5]
labels = ['0-1', '1-2', '2-3', '3-4', '4-5']
df_scores['score_range'] = pd.cut(df_scores['total_score'], bins=bins, labels=labels, include_lowest=True)

range_counts = df_scores['score_range'].value_counts().sort_index()
print("\nCompanies by score range:")
for range_label, count in range_counts.items():
    percentage = (count / len(df_scores)) * 100
    print(f"  {range_label}: {count} companies ({percentage:.1f}%)")

print("\n" + "="*80)
print("Top 10 Highest Scoring Companies:")
print("="*80)
top_10 = df_scores.nlargest(10, 'total_score')
print(top_10.to_string(index=False))

print("\n" + "="*80)
print("Bottom 10 Lowest Scoring Companies:")
print("="*80)
bottom_10 = df_scores.nsmallest(10, 'total_score')
print(bottom_10.to_string(index=False))

print("\n" + "="*80)
print("CONCLUSION")
print("="*80)
print(f"\nTotal companies: {len(df_scores)}")
print(f"Score range: {df_scores['total_score'].min():.4f} to {df_scores['total_score'].max():.4f}")
print(f"Average score: {df_scores['total_score'].mean():.4f}")
print(f"Median score: {df_scores['total_score'].median():.4f}")
print(f"\nMax theoretical score: ~5.0")
print(f"Average as % of max: {(df_scores['total_score'].mean() / 5.0) * 100:.1f}%")
