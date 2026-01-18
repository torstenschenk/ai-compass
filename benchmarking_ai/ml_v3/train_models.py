
import sys
import os
import pandas as pd
import numpy as np

# Add parent directory to path
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

from data_pipeline import DataPipeline
from models import ClusterEngine, AnomalyDetector, Recommender

ARTIFACT_DIR = os.path.join(os.path.dirname(__file__), 'model_artifacts')
if not os.path.exists(ARTIFACT_DIR):
    os.makedirs(ARTIFACT_DIR)

def train_and_save():
    print("=== Model Training Pipeline ===")
    
    # 1. Fetch Data
    print("Fetching training data...")
    dp = DataPipeline()
    dfs = dp.fetch_data()
    
    if not dfs:
        print("Error: Could not fetch data.")
        return
    
    q_matrix, d_matrix, profiles = dp.create_matrices(dfs)
    print(f"Training on {len(d_matrix)} companies.")
    
    # 2. Train Clustering
    print("Training ClusterEngine...")
    ce = ClusterEngine(n_clusters=5)
    ce.fit(d_matrix, cluster_profiles=profiles)
    ce.save_model(os.path.join(ARTIFACT_DIR, 'cluster_engine'))
    print("✓ ClusterEngine Saved")
    
    # 3. Train Anomaly Detector
    print("Training AnomalyDetector...")
    ad = AnomalyDetector()
    ad.fit(d_matrix)
    ad.save_model(os.path.join(ARTIFACT_DIR, 'anomaly_stats.json'))
    print("✓ AnomalyDetector Saved")
    
    # 4. Train Recommender
    print("Training Recommender...")
    rec = Recommender()
    rec.fit(d_matrix)
    rec.save_model(os.path.join(ARTIFACT_DIR, 'rec_engine'))
    print("✓ Recommender Saved")
    
    print(f"\nAll models saved to {ARTIFACT_DIR}")

if __name__ == "__main__":
    train_and_save()
