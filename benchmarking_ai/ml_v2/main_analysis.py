
import sys
import os
import matplotlib.pyplot as plt
import seaborn as sns
from data_pipeline import DataPipeline
from models import BenchmarkEngine, ClusterEngine
import pandas as pd

def main():
    print("--- Starting AI-Compass Benchmarking Pipeline ---")
    
    # 1. Data Loading
    print("[1/4] Fetching Data...")
    dp = DataPipeline()
    dfs = dp.fetch_data()
    
    if not dfs:
        print("Error: Could not fetch data. Check DB Connection.")
        return

    q_matrix, d_matrix, profiles = dp.create_matrices(dfs)
    print(f"      - Companies: {len(d_matrix)}")
    print(f"      - Dimensions: {d_matrix.shape[1]}")
    print(f"      - DB Profiles Loaded: {len(profiles)}")
    print(f"      - Profiles Columns: {profiles.columns.tolist()}")

    # 2. Benchmarking
    print("[2/4] Running Benchmark Engine...")
    meta = dfs['companies']
    ben = BenchmarkEngine(d_matrix, meta)
    
    # Helper to print sample
    sample_company = d_matrix.index[0]
    sample_dim = d_matrix.columns[0]
    perc = ben.calculate_percentile(sample_company, sample_dim)
    print(f"      - Sample: Company {sample_company} is in the {perc:.1f}th percentile for '{sample_dim}'")

    # 3. Clustering
    print("[3/4] Running Hybrid Cluster Engine...")
    clust = ClusterEngine(d_matrix, cluster_profiles=profiles)
    labels = clust.train()
    results = clust.get_results_df()
    
    # HYBRID LABELING (Dynamic from DB)
    cluster_names = clust.get_cluster_labels()
    results['Cluster_Name'] = results['Cluster'].map(cluster_names)
    
    # Ensure Cluster matches naming order for plotting
    results['Cluster_Sort'] = results['Cluster_Name'].apply(lambda x: int(x.split(' - ')[0]))
    
    print("      - Clustering Complete. Counts:")
    print(results['Cluster_Name'].value_counts())

    # 4. Reporting & Visualization
    print("[4/4] Generating Plots & Report...")
    
    # PCA Plot
    plt.figure(figsize=(12, 8))
    # Hue using descriptive Name, ensuring logical sort order
    sns.scatterplot(
        data=results.sort_values('Cluster_Sort'), 
        x='PCA_X', 
        y='PCA_Y', 
        hue='Cluster_Name', 
        palette='viridis', 
        s=100
    )
    plt.title('AI-Compass Company Clusters (5-Cluster Model)')
    plt.xlabel('Strategic Maturity (PCA 1)')
    plt.ylabel('Technical Readiness (PCA 2)')
    
    plot_path = os.path.join(os.path.dirname(__file__), 'cluster_pca.png')
    plt.savefig(plot_path)
    print(f"      - Saved Plot: {plot_path}")

    # NEW: Generate Text Report
    report_path = os.path.join(os.path.dirname(__file__), 'cluster_report.txt')
    with open(report_path, "w", encoding="utf-8") as f:
        f.write("--- Analyzing Cluster Definitions (5 Clusters - LOGICAL SCALE) ---\n\n")
        
        # Centroids
        f.write("Cluster Centroids (Mean Score per Dimension):\n")
        # Group by numeric Cluster to see all 5, include Name as a second level or column
        # centroids = results.groupby(['Cluster', 'Cluster_Name']).mean(numeric_only=True).drop(columns=['PCA_X', 'PCA_Y', 'Cluster_Sort'], errors='ignore')
        
        # Cleaner approach for the report text:
        grouped = results.groupby(['Cluster', 'Cluster_Name'])
        centroids = grouped.mean(numeric_only=True).drop(columns=['PCA_X', 'PCA_Y', 'Cluster_Sort'], errors='ignore')
        f.write(centroids.to_string() + "\n\n")
        
        # Interpret PCA
        f.write("--- PCA Component Interpretation ---\n")
        pca_components = clust.pca.components_
        feature_names = d_matrix.columns
        for i, component in enumerate(pca_components):
             f.write(f"\nPCA Component {i+1} Breakdown:\n")
             comp_series = pd.Series(component, index=feature_names).sort_values(ascending=False)
             f.write(comp_series.to_string() + "\n")

        # Detailed Cluster Stats
        f.write("\n--- Interpretation ---\n")
        for (cluster_id, cluster_name), row in centroids.iterrows():
            sorted_dims = row.sort_values(ascending=False)
            top = sorted_dims.head(2).index.tolist()
            bottom = sorted_dims.tail(2).index.tolist()
            count = len(results[(results['Cluster'] == cluster_id)])
            
            f.write(f"\nCluster {cluster_id} - Named: {cluster_name}:\n")
            f.write(f"  - Strongest: {', '.join(top)} ({sorted_dims[0]:.2f})\n")
            f.write(f"  - Weakest:   {', '.join(bottom)} ({sorted_dims[-1]:.2f})\n")
            f.write(f"  - Count:     {count} companies\n")
    
    print(f"      - Saved Report: {report_path}")

    print("\n--- Pipeline Finished Successfully ---")

if __name__ == "__main__":
    main()
