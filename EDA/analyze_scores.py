import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import os
import sys
from fetch_data import fetch_all_data

# Force UTF-8 output
sys.stdout.reconfigure(encoding='utf-8')

sns.set_theme(style="whitegrid")
plt.rcParams['figure.figsize'] = (12, 6)

def analyze_scores(data):
    """Analyze total scores demographics."""
    responses = data['responses']
    companies = data['companies']
    output_dir = 'EDA/plots'
    
    print(f"Analyzing scores for {len(responses)} responses...")
    
    # Merge responses with company info
    df = pd.merge(responses, companies, on='company_id')
    
    # 1. Score Distribution (Histogram)
    plt.figure(figsize=(10, 6))
    sns.histplot(data=df, x='total_score', bins=20, kde=True, color='purple')
    plt.title('Distribution of Total Scores')
    plt.xlabel('Total Score (0-5 scale)')
    plt.ylabel('Count')
    plt.tight_layout()
    plt.savefig(os.path.join(output_dir, 'scores_distribution.png'))
    plt.close()
    print("  Saved scores_distribution.png")
    
    # 2. Score Distribution (Boxplot)
    plt.figure(figsize=(8, 6))
    sns.boxplot(y=df['total_score'], color='lightblue')
    plt.title('Boxplot of Total Scores')
    plt.ylabel('Total Score')
    plt.tight_layout()
    plt.savefig(os.path.join(output_dir, 'scores_boxplot.png'))
    plt.close()
    print("  Saved scores_boxplot.png")
    
    # 3. Scores by Industry (Boxplot)
    plt.figure(figsize=(14, 8))
    # Sort by median score
    order = df.groupby('industry')['total_score'].median().sort_values(ascending=False).index
    sns.boxplot(data=df, x='industry', y='total_score', order=order, palette='coolwarm')
    plt.title('Total Scores by Industry')
    plt.xticks(rotation=45, ha='right')
    plt.xlabel('Industry')
    plt.ylabel('Total Score')
    plt.tight_layout()
    plt.savefig(os.path.join(output_dir, 'scores_by_industry.png'))
    plt.close()
    print("  Saved scores_by_industry.png")
    
    # 4. Scores by Company Size (Scatter)
    if 'number_of_employees' in df.columns:
        plt.figure(figsize=(10, 6))
        sns.scatterplot(data=df, x='number_of_employees', y='total_score', alpha=0.6, color='green')
        plt.title('Total Score vs Company Size (Employees)')
        plt.xlabel('Number of Employees')
        plt.ylabel('Total Score')
        plt.tight_layout()
        plt.savefig(os.path.join(output_dir, 'scores_vs_size.png'))
        plt.close()
        print("  Saved scores_vs_size.png")

    # Summary Stats
    with open('EDA/scores_analysis_summary.txt', 'w') as f:
        f.write("SCORES ANALYSIS SUMMARY\n")
        f.write("=======================\n\n")
        
        f.write("Overall Statistics:\n")
        f.write(df['total_score'].describe().to_string() + "\n\n")
        
        f.write("Scores by Industry (Mean):\n")
        industry_scores = df.groupby('industry')['total_score'].mean().sort_values(ascending=False)
        f.write(industry_scores.to_string() + "\n\n")
        
        # Outliers (IQR method)
        Q1 = df['total_score'].quantile(0.25)
        Q3 = df['total_score'].quantile(0.75)
        IQR = Q3 - Q1
        outliers = df[(df['total_score'] < (Q1 - 1.5 * IQR)) | (df['total_score'] > (Q3 + 1.5 * IQR))]
        
        f.write(f"Number of Outliers: {len(outliers)}\n")
        if not outliers.empty:
            f.write("Outlier Companies:\n")
            # Ensure columns exist
            cols = ['company_name', 'total_score', 'industry']
            cols = [c for c in cols if c in df.columns]
            f.write(outliers[cols].to_string())

    print("  Saved scores_analysis_summary.txt")

if __name__ == "__main__":
    data = fetch_all_data()
    analyze_scores(data)
