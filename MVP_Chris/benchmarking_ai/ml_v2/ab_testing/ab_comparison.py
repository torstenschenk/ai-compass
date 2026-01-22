
import sys
import os
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
from sklearn.metrics import silhouette_score, calinski_harabasz_score, davies_bouldin_score
from sklearn.decomposition import PCA
from sklearn.preprocessing import StandardScaler

# Add parent directory to path to import from ml_v2
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

from data_pipeline import DataPipeline
from models import ClusterEngine

def run_ab_test():
    print("=== Starting A/B Test: Rule-Based (DB) vs ML V2 (Hybrid) ===")
    
    # 1. Load Data
    dp = DataPipeline()
    dfs = dp.fetch_data()
    
    if not dfs:
        print("Error: Could not fetch data.")
        return

    # Create matrices (Dimension Matrix is our feature set X)
    q_matrix, d_matrix, profiles = dp.create_matrices(dfs)
    X = d_matrix.fillna(0)
    
    # Standardize data for metric calculation (important for distance-based metrics)
    scaler = StandardScaler()
    X_scaled = scaler.fit_transform(X)


    # ---------------------------------------------------------
    # Cohort A: Rule-Based (Database Assignments)
    # ---------------------------------------------------------
    print("\n[Cohort A] Loading Rule-Based Clusters from DB...")
    responses = dfs['responses']
    
    # Map company_id to cluster_id from responses table
    company_cluster_map = responses.set_index('company_id')['cluster_id'].to_dict()
    
    # Create labels array aligned with X
    labels_a = [company_cluster_map.get(cid, -1) for cid in d_matrix.index]
    labels_a = np.array(labels_a)

    # Filter out companies that might not have a cluster assignment (-1)
    valid_indices = labels_a != -1
    if not np.all(valid_indices):
        print(f"Warning: {sum(~valid_indices)} companies missing DB cluster assignment. Excluding them from Cohort A metrics.")
        X_scaled_a = X_scaled[valid_indices]
        labels_a = labels_a[valid_indices]
    else:
        X_scaled_a = X_scaled

    # Map DB numeric IDs to Names
    # profiles has 'cluster_id' and 'cluster_name'
    # Format: "ID - Name" to match ML v2 style
    db_id_to_name = {
        row['cluster_id']: f"{row['cluster_id']} - {row['cluster_name']}" 
        for _, row in profiles.iterrows()
    }
    # Apply mapping, defaulting to "Unknown" if not found
    labels_a_names = np.array([db_id_to_name.get(uid, f"{uid} - Unknown") for uid in labels_a])
        
    # ---------------------------------------------------------
    # Cohort B: ML V2 (Hybrid Clustering)
    # ---------------------------------------------------------
    print("\n[Cohort B] Generating ML V2 Clusters...")
    clust_engine = ClusterEngine(d_matrix, cluster_profiles=profiles, n_clusters=5)
    labels_b_numeric = clust_engine.train() # This returns the labels directly
    X_scaled_b = X_scaled # ML v2 clusters all companies
    
    # Get Semantic Labels from Engine
    # returns dict: {cluster_idx: "ID - Name"}
    ml_label_map = clust_engine.get_cluster_labels()
    labels_b_names = np.array([ml_label_map[l] for l in labels_b_numeric])

    # ---------------------------------------------------------
    # Metric Calculation
    # ---------------------------------------------------------
    
    def calculate_metrics(X, labels, name):
        if len(set(labels)) < 2:
            return {"Silhouette": np.nan, "Calinski-Harabasz": np.nan, "Davies-Bouldin": np.nan}
            
        sil = silhouette_score(X, labels)
        ch = calinski_harabasz_score(X, labels)
        db = davies_bouldin_score(X, labels)
        
        print(f"\nResults for {name}:")
        print(f"  Silhouette Score:       {sil:.4f} (Higher is better, range -1 to 1)")
        print(f"  Calinski-Harabasz:      {ch:.4f} (Higher is better)")
        print(f"  Davies-Bouldin:         {db:.4f} (Lower is better)")
        
        return {"Silhouette": sil, "Calinski-Harabasz": ch, "Davies-Bouldin": db}

    # Pass numeric labels to metrics for safety (though sklearn handles strings too, this is robust)
    metrics_a = calculate_metrics(X_scaled_a, labels_a, "Cohort A (Rule-Based)")
    metrics_b = calculate_metrics(X_scaled_b, labels_b_numeric, "Cohort B (ML V2)")

    # ---------------------------------------------------------
    # Report Generation
    # ---------------------------------------------------------
    report_path = os.path.join(os.path.dirname(__file__), 'ab_comparison_report.txt')
    with open(report_path, 'w') as f:
        f.write("================================================================================\n")
        f.write("A/B TEST REPORT: Rule-Based (DB) vs ML V2 (Hybrid)\n")
        f.write("================================================================================\n\n")
        
        f.write("1. METRIC COMPARISON\n")
        f.write("--------------------\n")
        f.write(f"{'Metric':<25} | {'Rule-Based (DB)':<20} | {'ML V2 (Hybrid)':<20} | {'Winner':<10}\n")
        f.write("-" * 85 + "\n")
        
        for metric in metrics_a.keys():
            val_a = metrics_a[metric]
            val_b = metrics_b[metric]
            
            # Determine winner
            if metric == "Davies-Bouldin":
                winner = "ML V2" if val_b < val_a else "Rule-Based"
            else:
                winner = "ML V2" if val_b > val_a else "Rule-Based"
                
            f.write(f"{metric:<25} | {val_a:<20.4f} | {val_b:<20.4f} | {winner:<10}\n")
            
        f.write("\n\n2. INTERPRETATION\n")
        f.write("-----------------\n")
        f.write("- Silhouette Score: Indicates how well-separated the clusters are. ML V2 optimized for this in feature space.\n")
        f.write("- Calinski-Harabasz: Relates variance between clusters to variance within clusters.\n")
        f.write("- Davies-Bouldin: Measures average similarity between clusters (lower is better separation).\n")
        
        f.write("\n\n3. DISTRIBUTION COMPARISON\n")
        f.write("--------------------------\n")
        
        # Get counts using NAMED labels directly
        unique_a, counts_a = np.unique(labels_a_names, return_counts=True)
        unique_b, counts_b = np.unique(labels_b_names, return_counts=True)
        
        # Sort so they appear in logical order (strings "1 - ...", "2 - ..." sort well)
        
        f.write("Rule-Based Counts:\n") 
        for lab, count in zip(unique_a, counts_a):
             f.write(f"  {lab}: {count}\n")
             
        f.write("\nML V2 Counts:\n")
        for lab, count in zip(unique_b, counts_b):
             f.write(f"  {lab}: {count}\n")

    print(f"\nReport saved to: {report_path}")

    # ---------------------------------------------------------
    # Visualization (Side-by-Side PCA)
    # ---------------------------------------------------------
    pca = PCA(n_components=2)
    X_pca = pca.fit_transform(X_scaled)
    
    # Create simple dataframes for plotting
    # We need to make sure df_plot_a aligns with filtered X_scaled_a if any were dropped
    if len(labels_a) != len(X_pca):
         X_pca_a = pca.transform(X_scaled_a) # Use same PCA projection
         df_plot_a = pd.DataFrame(X_pca_a, columns=['PC1', 'PC2'])
    else:
         df_plot_a = pd.DataFrame(X_pca, columns=['PC1', 'PC2'])
         
    df_plot_a['Cluster'] = labels_a_names
    
    df_plot_b = pd.DataFrame(X_pca, columns=['PC1', 'PC2'])
    df_plot_b['Cluster'] = labels_b_names

    fig, axes = plt.subplots(1, 2, figsize=(18, 8))
    
    # Sort hue order for consistent legend
    hue_order_a = sorted(np.unique(labels_a_names))
    hue_order_b = sorted(np.unique(labels_b_names))
    
    sns.scatterplot(data=df_plot_a, x='PC1', y='PC2', hue='Cluster', hue_order=hue_order_a, palette='viridis', ax=axes[0], s=80, alpha=0.7)
    axes[0].set_title('Cohort A: Rule-Based (Database)')
    axes[0].grid(True, linestyle='--', alpha=0.5)
    
    sns.scatterplot(data=df_plot_b, x='PC1', y='PC2', hue='Cluster', hue_order=hue_order_b, palette='viridis', ax=axes[1], s=80, alpha=0.7)
    axes[1].set_title('Cohort B: ML V2 (Hybrid Clustering)')
    axes[1].grid(True, linestyle='--', alpha=0.5)
    
    plt.suptitle("Cluster Separation Comparison (PCA Projection)", fontsize=16)
    
    plot_path = os.path.join(os.path.dirname(__file__), 'ab_comparison_plots.png')
    plt.savefig(plot_path)
    print(f"Plots saved to: {plot_path}")
    plt.close()

if __name__ == "__main__":
    run_ab_test()
