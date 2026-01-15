
import sys
import os
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt

# Add parent directory to path to import ml_v1 modules
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

from data_pipeline import DataPipeline
from models import ClusterEngine

def run_ab_test():
    print("--- Starting A/B Testing (New vs Old) ---")
    
    # 1. Fetch & Prepare Data
    print("[1/3] Fetching Data...")
    dp = DataPipeline()
    dfs = dp.fetch_data()
    if not dfs: return

    # Fetch Cluster Profiles (Names)
    # Using raw SQL since DataPipeline doesn't fetch this table by default
    print("      - Fetching Legacy Cluster Definitions...")
    cur = dp.conn.cursor()
    cur.execute("SELECT cluster_id, cluster_name FROM cluster_profiles")
    profiles = pd.DataFrame(cur.fetchall(), columns=['cluster_id', 'cluster_name'])
    cur.close()
    
    # Map ID to Name (Format: "ID - Name")
    # profiles['cluster_id'] is an integer, ensure conversion if needed
    cluster_map = {row['cluster_id']: f"{row['cluster_id']} - {row['cluster_name']}" for _, row in profiles.iterrows()}

    # Get Old Cluster Info
    responses = dfs['responses'].copy()
    # Ensure One Response Per Company (taking latest if multiple)
    responses = responses.sort_values('created_at', ascending=False).drop_duplicates('company_id')
    
    # 2. Run New Model
    print("[2/3] Running New 5-Cluster Model...")
    _, d_matrix, _ = dp.create_matrices(dfs)
    clust = ClusterEngine(d_matrix, n_clusters=5)
    clust.train()
    new_results = clust.get_results_df() # Has 'Cluster' (0-4)
    
    # 3. Merge & Compare
    print("[3/3] Comparing...")
    
    # Merge New Clusters with Old Clusters
    comparison = new_results[['Cluster']].rename(columns={'Cluster': 'New_Cluster_5'})
    
    # REMAP IDs to Logical 1-5 Scale (Laggard -> Leader)
    # Current Mapping (from analysis): 4=Laggard, 1=Data/Tech-Poor, 0=Middle, 2=Tech Spec, 3=Leader
    id_remap = {
        4: 1, # Laggard
        1: 2, # Data-Rich / Tech-Poor
        0: 3, # Middle Pack
        2: 4, # Tech Specialists
        3: 5  # Leaders
    }
    comparison['New_Cluster_5'] = comparison['New_Cluster_5'].map(id_remap)

    comparison = comparison.merge(responses[['company_id', 'cluster_id']], on='company_id', how='left')
    
    # Map Legacy ID to Name
    comparison['Legacy_Caluster_Name'] = comparison['cluster_id'].map(cluster_map).fillna('Unknown')
    
    # Map New Cluster ID to Descriptive Name
    new_cluster_names = {
        1: "1 - Laggards",
        2: "2 - Data-Rich / Tech-Poor",
        3: "3 - Middle Pack",
        4: "4 - Tech Specialists",
        5: "5 - Leaders"
    }
    comparison['New_Cluster_Name'] = comparison['New_Cluster_5'].map(new_cluster_names)
    
    # Fill NaN
    comparison = comparison.dropna(subset=['cluster_id'])
    
    # Crosstab (Legacy Name vs New Name)
    ct = pd.crosstab(comparison['Legacy_Caluster_Name'], comparison['New_Cluster_Name'])
    
    # Report
    print("\nConfusion Matrix (Rows=Legacy, Cols=New):")
    print(ct)
    
    # Save Report
    report_path = os.path.join(os.path.dirname(__file__), 'ab_test_report.txt')
    with open(report_path, "w", encoding="utf-8") as f:
        f.write("--- A/B Test Report: Existing Legacy Clusters vs New ML Model (5 vs 5) ---\n\n")
        f.write("Confusion Matrix counts:\n")
        f.write(ct.to_string() + "\n\n")
        
        # Interpretation Logic
        f.write("Interpretation:\n")
        # For each Old Cluster, where did they go?
        for legacy_name in ct.index:
            total = ct.loc[legacy_name].sum()
            f.write(f"\nLegacy Cluster '{legacy_name}' (Total {total}):\n")
            percentages = (ct.loc[legacy_name] / total * 100).sort_values(ascending=False)
            for new_c, pct in percentages.items():
                if pct > 0:
                    f.write(f"  -> {pct:.1f}% moved to New Cluster {new_c}\n")
                    
    print(f"      - Saved Report: {report_path}")
    
    # Plot Heatmap
    plt.figure(figsize=(12, 8))
    sns.heatmap(ct, annot=True, fmt='d', cmap='Blues')
    plt.title('A/B Test: Legacy DB Clusters vs New ML Clusters')
    plt.xlabel('New ML Clusters')
    plt.ylabel('Legacy DB Clusters')
    plt.tight_layout()
    
    plot_path = os.path.join(os.path.dirname(__file__), 'ab_heatmap.png')
    plt.savefig(plot_path)
    print(f"      - Saved Plot: {plot_path}")

if __name__ == "__main__":
    run_ab_test()
