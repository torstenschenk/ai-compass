
import sys
import os
import pandas as pd
import numpy as np
import json

# Add parent directory to path
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

from models import ClusterEngine, AnomalyDetector, Recommender

ARTIFACT_DIR = os.path.join(os.path.dirname(__file__), 'model_artifacts')

from data_pipeline import DataPipeline

class AICompassInference:
    def __init__(self):
        self.ce = ClusterEngine()
        self.ad = AnomalyDetector()
        self.rec = Recommender()
        self._load_models()

    def _load_models(self):
        print("Loading AI-Compass Models...")
        try:
            self.ce.load_model(os.path.join(ARTIFACT_DIR, 'cluster_engine'))
            self.ad.load_model(os.path.join(ARTIFACT_DIR, 'anomaly_stats.json'))
            self.rec.load_model(os.path.join(ARTIFACT_DIR, 'rec_engine'))
            print("✓ Models Loaded")
        except Exception as e:
            print(f"Error loading models: {e}")
            print("Please run train_models.py first.")

    def analyze_company(self, scores_dict):
        """
        Args:
            scores_dict (dict): Dictionary of dimension scores {Dimension Name: Score (1-5)}
        Returns:
            dict: Analysis results
        """
        company_df = pd.DataFrame([scores_dict])
        
        # 1. Cluster Prediction
        cluster_id, cluster_names, _ = self.ce.predict(company_df)
        
        # 2. Anomaly Detection
        anomalies = self.ad.detect(company_df.iloc[0])
        
        # 3. Recommendation
        rec_dim, rec_text = self.rec.recommend(company_df.iloc[0])
        
        return {
            "Cluster_ID": int(cluster_id[0]),
            "Cluster_Name": cluster_names[0],
            "Anomalies": anomalies,
            "Recommendation": {
                "Focus_Area": rec_dim,
                "Rationale": rec_text
            }
        }

def fetch_company_profile_from_db(company_id):
    """Refetches data to find a specific company's profile."""
    print(f"Fetching profile for Company {company_id} from DB...")
    dp = DataPipeline()
    dfs = dp.fetch_data()
    q_matrix, d_matrix, _ = dp.create_matrices(dfs)
    
    if company_id not in d_matrix.index:
        print(f"Company {company_id} not found in DB.")
        return None
        
    # Convert Series to dict
    return d_matrix.loc[company_id].to_dict()

if __name__ == "__main__":
    engine = AICompassInference()

    # ---------------------------------------------------------
    # Scenario A: Synthetic "Structural Imbalance"
    # ---------------------------------------------------------
    print("\n=== Test A: Synthetic Data (Detecting Logic Sensitivity) ===")
    input_profile_imbalanced = {
        'Data Readiness & Literacy': 3.5,
        'Governance & Compliance': 2.0,
        'People & Culture': 2.0,
        'Processes & Scaling': 3.0,
        'Strategy & Business Vision': 1.5, # Huge gap vs Tech (4.5)
        'Tech Infrastructure': 4.5,
        'Use Cases & Business Value': 3.0
    }
    result_a = engine.analyze_company(input_profile_imbalanced)
    print("Input: High Tech (4.5) / Low Strategy (1.5)")
    print(json.dumps(result_a, indent=2))
    
    # ---------------------------------------------------------
    # Scenario B: Real Data (Company ID 3)
    # ---------------------------------------------------------
    print("\n=== Test B: Real DB Data (Integration Test) ===")
    company_id = 3
    real_profile = fetch_company_profile_from_db(company_id)
    
    if real_profile:
        print(f"Profile for Company {company_id}:")
        # Print a few scores for context
        print({k: round(v, 2) for k, v in list(real_profile.items())[:3]}) 
        
        result_b = engine.analyze_company(real_profile)
        print("\nAnalysis Result:")
        print(json.dumps(result_b, indent=2))
