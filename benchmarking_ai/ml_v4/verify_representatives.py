
import pandas as pd
import os
import json
from benchmarking_ai.ml_v4.data_pipeline import DataPipeline
from benchmarking_ai.ml_v4.inference import InferenceEngine

def generate_report():
    print("Verifying ML v4 on Cluster Representatives...")
    
    # 1. Fetch Data
    dp = DataPipeline()
    dfs = dp.fetch_data()
    q_matrix, d_matrix, profiles, q_meta = dp.create_matrices(dfs)
    
    # 2. Initialize Inference Engine
    # Note: training must be run first to exist at this path
    # InferenceEngine resolves path relative to itself (ml_v4/inference.py)
    # So we just need "model_artifacts/v4"
    engine = InferenceEngine(artifacts_path="model_artifacts/v4")
    
    # 3. Representatives
    # 4 - Scaler -> 46
    # 1 - Traditionalist -> 31
    # 2 - Explorer -> 3
    # 5 - Leader -> 17
    # 3 - Builder -> 32
    representatives = [46, 31, 3, 17, 32]
    
    report = "# Verification: 5 Cluster Representatives (ML v4)\n\n"
    report += "This report validates the **ML v4** pipeline, featuring:\n"
    report += "- **Strategic Gap Analysis**: Z-Score Anomalies + Weighted Impact Checks.\n"
    report += "- **Hybrid Roadmap**: 3-Phase Plan guaranteed for every profile, integrating Strategic Gaps + Peer-Validated Growth Opportunities.\n"
    report += "- **Narrative Generation**: Automated executive briefings.\n\n"
    
    print(f"Index Type: {d_matrix.index.dtype}")
    
    for cid in representatives:
        # robust check
        if cid not in d_matrix.index:
            # Try string
            if str(cid) in d_matrix.index:
                cid = str(cid)
            elif int(cid) in d_matrix.index:
                cid = int(cid)
            else:
                print(f"Skipping {cid} (Not in data). Available: {d_matrix.index.tolist()[:5]}...")
                continue
            
        print(f"Analyzing Company {cid}...")
        
        # Prepare Inputs
        company_dim = d_matrix.loc[cid]
        
        # Get Company Question Data with metadata
        # q_matrix is just scores. We need rich data.
        # reconstruct from q_meta?
        # We need: question_id, question_weight, score_1to5, question_type, tactical_theme, dimension_name
        
        # We can merge q_meta with the company's scores from q_matrix
        company_scores = q_matrix.loc[cid].reset_index(name='score_1to5')
        # Merge
        company_q_rich = company_scores.merge(q_meta, on='question_id', how='left')
        
        # Run Analysis
        result = engine.run_analysis(company_dim, company_q_rich)
        
        if "error" in result:
            print(f"Error for {cid}: {result['error']}")
            continue
            
        # Format Output for Markdown Report
        c_name = result['cluster']['cluster_name']
        
        report += f"---\n\n## Cluster Representative: {cid} ({c_name})\n\n"
        
        # Profile Table
        report += "### 1. Profile Scores\n"
        report += "| Dimension | Score (1-5) |\n| :--- | :---: |\n"
        for dim, score in company_dim.items():
            report += f"| {dim} | {score:.2f} |\n"
        report += "\n"
        
        # Findings
        report += "### 2. Strategic Findings\n"
        for f in result['strategic_findings']:
            icon = "🔴" if f['type'] == 'Anomaly' else "⚠️"
            report += f"- {icon} **{f['title']}** (Severity: {f['score']:.1f})\n"
            report += f"  - *Context*: {f['context']}\n"
        report += "\n"
        
        # Briefing
        report += "### 3. Executive Briefing\n"
        report += f"> {result['executive_briefing'].replace(chr(10), chr(10)+'> ')}\n\n"
        
        # Roadmap
        report += "### 4. Strategic Roadmap\n"
        roadmap = result['roadmap']
        for phase, items in roadmap.items():
            report += f"#### {phase}\n"
            if not items:
                report += "- *No items (Unexpected)*\n"
            for i in items:
                source_tag = f"[{i['source']}]"
                report += f"- **{i['theme']}** {source_tag} (Impact: {i['impact']:.1f})\n"
        
        report += "\n"
        
    # Save Report
    with open("benchmarking_ai/ml_v4/cluster_representative_test_findings.md", "w", encoding='utf-8') as f:
        f.write(report)
        
    print("✅ Verification Report Generated.")

if __name__ == "__main__":
    generate_report()
