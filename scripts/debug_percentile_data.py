import pandas as pd
import os

PATH = r"d:\SpicedProjects\Projects\ai-compass\benchmarking_ai\ml_v5\model_artifacts\v5_industry_data.pkl"

if not os.path.exists(PATH):
    print(f"File not found: {PATH}")
else:
    df = pd.read_pickle(PATH)
    print(f"Loaded industry data with {len(df)} rows.")
    print("\nColumns:", df.columns.tolist())
    if 'industry' in df.columns:
        print("\nUnique Industries and counts:")
        print(df['industry'].value_counts())
    else:
        print("Column 'industry' not found!")
    
    print("\nSample rows:")
    print(df.head())
