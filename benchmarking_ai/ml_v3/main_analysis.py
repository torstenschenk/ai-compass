
import sys
import os
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns

# Add parent directory to path
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

from data_pipeline import DataPipeline
from models import ClusterEngine, AnomalyDetector, Recommender

def run_comprehensive_analysis():
    print("=== AI-Compass ML v3: Comprehensive Analysis ===")
    
    # 1. Pipeline
    dp = DataPipeline()
    dfs = dp.fetch_data()
    
    if not dfs:
        print("Error: Could not fetch data.")
        return
        
    q_matrix, d_matrix, profiles = dp.create_matrices(dfs)
    print(f"Loaded {len(d_matrix)} companies.")
    
    # 2. Hybrid Clustering (Macro-Segmentation)
    print("\n[1/3] Running Hybrid Clustering...")
    clust_engine = ClusterEngine(d_matrix, cluster_profiles=profiles, n_clusters=5)
    clust_engine.train()
    results = clust_engine.get_results_df()
    
    # Apply Semantic Labels
    label_map = clust_engine.get_cluster_labels()
    results['Cluster_Name'] = results['Cluster'].map(label_map)
    
    # 3. Anomaly Detection (Risk Analysis)
    print("[2/3] Detecting Structural Anomalies...")
    detector = AnomalyDetector(d_matrix)
    detector.train()
    
    # Collect anomalies for all companies
    anomaly_report = []
    for company_id in d_matrix.index:
        findings = detector.detect_anomalies(company_id)
        if findings:
            results.loc[company_id, 'Has_Anomaly'] = True
            results.loc[company_id, 'Anomalies'] = "; ".join(findings)
            anomaly_report.extend(findings)
        else:
            results.loc[company_id, 'Has_Anomaly'] = False
            results.loc[company_id, 'Anomalies'] = "None"
            
    # 4. Recommendation Engine (Next Best Action)
    print("[3/3] Generating Recommendations...")
    rec_engine = Recommender(d_matrix)
    rec_engine.train()
    
    recs = []
    for company_id in d_matrix.index:
        dim, rationale = rec_engine.get_recommendation(company_id)
        if dim:
            results.loc[company_id, 'Recommended_Action'] = dim
            results.loc[company_id, 'Rec_Rationale'] = rationale
            recs.append(dim)
        else:
            results.loc[company_id, 'Recommended_Action'] = "Maintain"
            results.loc[company_id, 'Rec_Rationale'] = rationale

    # 5. Generate Report
    report_path = os.path.join(os.path.dirname(__file__), 'comprehensive_report.txt')
    with open(report_path, 'w') as f:
        f.write("================================================================================\n")
        f.write("AI-COMPASS ML v3: COMPREHENSIVE INTELLIGENCE REPORT\n")
        f.write("================================================================================\n\n")
        
        # Section 1: Cluster Distribution
        f.write("1. MACRO-SEGMENTATION (CLUSTERS)\n")
        f.write("--------------------------------\n")
        dist = results['Cluster_Name'].value_counts().sort_index()
        f.write(dist.to_string())
        f.write("\n\n")
        
        # Section 2: Anomaly Analysis
        f.write("2. RISK ANALYSIS (ANOMALIES)\n")
        f.write("----------------------------\n")
        n_anomalies = results['Has_Anomaly'].sum()
        f.write(f"Total Companies with Structural Anomalies: {n_anomalies} ({n_anomalies/len(d_matrix)*100:.1f}%)\n\n")
        f.write("Top Detected Risks:\n")
        
        # Simple text analysis of anomalies
        anomaly_series = pd.Series(anomaly_report)
        if not anomaly_series.empty:
             # Extract the "Type" of anomaly (e.g., "Critical Imbalance" or "Bottleneck")
             # Assuming format "Type: d1 vs d2..."
             types = anomaly_series.apply(lambda x: x.split(':')[0])
             f.write(types.value_counts().to_string())
        else:
             f.write("No significant anomalies detected.")
        f.write("\n\n")
        
        # Section 3: Recommendation Analysis
        f.write("3. STRATEGIC RECOMMENDATIONS (NEXT BEST ACTION)\n")
        f.write("-----------------------------------------------\n")
        rec_dist = results['Recommended_Action'].value_counts()
        f.write("Most Common Recommended Next Steps:\n")
        f.write(rec_dist.head(10).to_string())
        
        f.write("\n\n")
        
        # Sample Profile
        f.write("4. SAMPLE PROFILE (Company ID: 5)\n")
        f.write("---------------------------------\n")
        if 5 in results.index:
            row = results.loc[5]
            f.write(f"Cluster:        {row['Cluster_Name']}\n")
            f.write(f"Anomalies:      {row['Anomalies']}\n")
            f.write(f"Recommendation: Focus on '{row['Recommended_Action']}'\n")
            f.write(f"Rationale:      {row['Rec_Rationale']}\n")
        else:
             f.write("Company 5 not found in dataset.\n")

    print(f"\nReport generated: {report_path}")
    
    # Optional: Save extended results to CSV for debugging
    csv_path = os.path.join(os.path.dirname(__file__), 'full_results.csv')
    results.to_csv(csv_path)
    print(f"Full results saved: {csv_path}")

if __name__ == "__main__":
    run_comprehensive_analysis()
