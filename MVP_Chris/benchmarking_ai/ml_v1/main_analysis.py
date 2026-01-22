
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

    q_matrix, d_matrix, meta = dp.create_matrices(dfs)
    print(f"      - Companies: {len(d_matrix)}")
    print(f"      - Dimensions: {d_matrix.shape[1]}")

    # 2. Benchmarking
    print("[2/4] Running Benchmark Engine...")
    ben = BenchmarkEngine(d_matrix, meta)
    
    # Helper to print sample
    sample_company = d_matrix.index[0]
    sample_dim = d_matrix.columns[0]
    perc = ben.calculate_percentile(sample_company, sample_dim)
    print(f"      - Sample: Company {sample_company} is in the {perc:.1f}th percentile for '{sample_dim}'")

    # 3. Clustering
    print("[3/4] Running Cluster Engine...")
    clust = ClusterEngine(d_matrix, n_clusters=5)
    labels = clust.train()
    results = clust.get_results_df()
    
    # REMAP IDs to Logical 1-5 Scale (Laggard -> Leader)
    # Mapping based on analysis of random_state=42
    id_remap = {
        4: 1, # Laggard
        1: 2, # Data-Rich / Tech-Poor
        0: 3, # Middle Pack
        2: 4, # Tech Specialists
        3: 5  # Leaders
    }
    results['Cluster'] = results['Cluster'].map(id_remap)
    
    new_cluster_names = {
        1: "1 - Laggards",
        2: "2 - Data-Rich / Tech-Poor",
        3: "3 - Middle Pack",
        4: "4 - Tech Specialists",
        5: "5 - Leaders"
    }
    results['Cluster_Name'] = results['Cluster'].map(new_cluster_names)
    
    print("      - Clustering Complete. Counts:")
    print(results['Cluster_Name'].value_counts())

    # 4. Reporting & Visualization
    print("[4/4] Generating Plots & Report...")
    
    # PCA Plot
    plt.figure(figsize=(12, 8))
    # Hue using descriptive Name, ensuring logical sort order
    sns.scatterplot(
        data=results.sort_values('Cluster'), 
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
        # Group by Name to get readable output
        centroids = results.groupby('Cluster_Name').mean(numeric_only=True).drop(columns=['Cluster', 'PCA_X', 'PCA_Y'], errors='ignore')
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
        for cluster_name, row in centroids.iterrows():
            sorted_dims = row.sort_values(ascending=False)
            top = sorted_dims.head(2).index.tolist()
            bottom = sorted_dims.tail(2).index.tolist()
            count = len(results[results['Cluster_Name'] == cluster_name])
            
            f.write(f"\nCluster {cluster_name}:\n")
            f.write(f"  - Strongest: {', '.join(top)} ({sorted_dims[0]:.2f})\n")
            f.write(f"  - Weakest:   {', '.join(bottom)} ({sorted_dims[-1]:.2f})\n")
            f.write(f"  - Count:     {count} companies\n")
    
    print(f"      - Saved Report: {report_path}")

    print("\n--- Pipeline Finished Successfully ---")

if __name__ == "__main__":
    main()
