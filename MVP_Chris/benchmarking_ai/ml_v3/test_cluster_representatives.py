
import sys
import os
import pandas as pd
import json

# Add parent directory to path
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

from data_pipeline import DataPipeline
from inference import AICompassInference

def run_representative_test():
    print("=== Testing One Representative Per Cluster ===")
    
    # 1. Load Data & Models
    dp = DataPipeline()
    dfs = dp.fetch_data()
    q_matrix, d_matrix, _ = dp.create_matrices(dfs)
    
    engine = AICompassInference()
    
    # 2. Get Cluster Assignments for ALL companies
    print("Classifying dataset to find representatives...")
    # predict returns (ids, names, coords)
    cluster_ids, cluster_names, _ = engine.ce.predict(d_matrix)
    
    d_matrix['Cluster_Label'] = cluster_ids
    d_matrix['Cluster_Name'] = cluster_names
    
    # 3. Pick one company_id for each unique cluster (0-4)
    # We want to ensure we get all 5 if they exist
    representatives = {}
    for c_id in range(5): # Clusters 0-4
        # Find first company in this cluster
        subset = d_matrix[d_matrix['Cluster_Label'] == c_id]
        if not subset.empty:
            company_id = subset.index[0]
            representatives[c_id] = company_id
        else:
            print(f"Warning: No companies found for Cluster {c_id}")

    # 4. Run Analysis & Report
    findings_path = os.path.join(os.path.dirname(__file__), 'cluster_representative_test_findings.md')
    
    with open(findings_path, 'w', encoding='utf-8') as f:
        f.write("# Verification: 5 Cluster Representatives\n\n")
        f.write("This report validates the ML v3 pipeline across all 5 semantic archetypes.\n\n")
        
        # Sort by cluster ID for readability
        for c_id in sorted(representatives.keys()):
            comp_id = representatives[c_id]
            
            # Get the exact input scores for this company
            profile_series = d_matrix.loc[comp_id].drop(['Cluster_Label', 'Cluster_Name'])
            profile_dict = profile_series.to_dict()
            
            # Run Inference
            result = engine.analyze_company(profile_dict)
            
            f.write(f"## Cluster {c_id}: {result['Cluster_Name']}\n")
            f.write(f"**Representative Company ID**: `{comp_id}`\n\n")
            
            f.write("### 1. Profile Scores\n")
            f.write("| Dimension | Score (1-5) |\n")
            f.write("| :--- | :---: |\n")
            for k, v in sorted(profile_dict.items()):
                f.write(f"| {k} | {v:.2f} |\n")
            f.write("\n")
                
            f.write("### 2. Analysis Output\n")
            
            # Anomalies
            anoms = result['Anomalies']
            if anoms:
                f.write("#### ⚠️ Detected Anomalies\n")
                for a in anoms:
                    f.write(f"- 🔴 {a}\n")
            else:
                f.write("#### ✅ Anomalies\n")
                f.write("- None detected (Balanced Profile)\n")
                
            f.write("\n")
            
            # Recommendations
            rec = result['Recommendation']
            f.write("#### 🚀 Recommended Focus Area\n")
            f.write(f"- **Focus**: {rec['Focus_Area']}\n")
            f.write(f"- **Rationale**: {rec['Rationale']}\n")
            
            f.write("\n---\n\n")
            
    print(f"✓ Findings saved to: {findings_path}")

if __name__ == "__main__":
    run_representative_test()
