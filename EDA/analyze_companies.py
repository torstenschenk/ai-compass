import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import os
import sys
from fetch_data import fetch_all_data

# Force UTF-8 output
sys.stdout.reconfigure(encoding='utf-8')

# Set plot style
sns.set_theme(style="whitegrid")
plt.rcParams['figure.figsize'] = (12, 6)

def analyze_companies(data):
    """Analyze company demographics."""
    df = data['companies']
    output_dir = 'EDA/plots'
    
    print(f"Analyzing {len(df)} companies...")
    
    # 1. Industry Distribution
    plt.figure(figsize=(12, 8))
    industry_counts = df['industry'].value_counts()
    sns.barplot(x=industry_counts.values, y=industry_counts.index, palette='viridis')
    plt.title('Company Distribution by Industry')
    plt.xlabel('Count')
    plt.ylabel('Industry')
    plt.tight_layout()
    plt.savefig(os.path.join(output_dir, 'companies_by_industry.png'))
    plt.close()
    print("  Saved companies_by_industry.png")
    
    # 2. City Distribution (Top 15) - replacing Country
    if 'city' in df.columns:
        plt.figure(figsize=(12, 8))
        city_counts = df['city'].value_counts().head(15) # Top 15
        
        # Ensure indices are strings for plotting
        city_counts.index = city_counts.index.astype(str)
        
        sns.barplot(x=city_counts.values, y=city_counts.index, palette='magma')
        plt.title('Top 15 Cities')
        plt.xlabel('Count')
        plt.tight_layout()
        plt.savefig(os.path.join(output_dir, 'companies_by_city.png'))
        plt.close()
        print("  Saved companies_by_city.png")
    
    # 3. Company Size (Employees)
    if 'number_of_employees' in df.columns:
        plt.figure(figsize=(10, 6))
        sns.histplot(data=df, x='number_of_employees', bins=30, kde=True, color='teal')
        plt.title('Distribution of Company Size (Employees)')
        plt.xlabel('Number of Employees')
        plt.ylabel('Count')
        plt.tight_layout()
        plt.savefig(os.path.join(output_dir, 'companies_size_dist.png'))
        plt.close()
        print("  Saved companies_size_dist.png")
    
    # Text Analysis Summary - Write to file (UTF-8)
    try:
        with open('EDA/company_analysis_summary.txt', 'w', encoding='utf-8') as f:
            f.write("COMPANY ANALYSIS SUMMARY\n")
            f.write("========================\n\n")
            f.write(f"Total Companies: {len(df)}\n")
            f.write(f"Unique Industries: {df['industry'].nunique()}\n")
            if 'city' in df.columns:
                f.write(f"Unique Cities: {df['city'].nunique()}\n\n")
            
            f.write("Top 5 Industries:\n")
            f.write(industry_counts.head(5).to_string() + "\n\n")
            
            if 'city' in df.columns:
                f.write("Top 5 Cities:\n")
                f.write(df['city'].value_counts().head(5).to_string() + "\n\n")
            
            f.write("Size Statistics:\n")
            cols_to_desc = [c for c in ['number_of_employees'] if c in df.columns]
            if cols_to_desc:
                f.write(df[cols_to_desc].describe().to_string() + "\n")

        print("  Saved company_analysis_summary.txt")
    except Exception as e:
        print(f"Error writing summary: {e}")

if __name__ == "__main__":
    try:
        data = fetch_all_data()
        analyze_companies(data)
    except Exception as e:
        print(f"Analysis failed: {e}")
