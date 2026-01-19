
import os
from benchmarking_ai.ml_v4.data_pipeline import DataPipeline
from benchmarking_ai.ml_v4.models import ClusterEngine, StrategicGapAnalyzer, RoadmapGenerator

def train_and_save():
    print("🚀 Starting Training Pipeline [ML v4]...")
    
    # 1. Fetch Data
    dp = DataPipeline()
    dfs = dp.fetch_data()
    q_matrix, d_matrix, profiles, q_meta = dp.create_matrices(dfs)
    
    print(f"✓ Data Loaded. Companies: {len(d_matrix)}")
    
    # Ensure artifacts dir exists in the module folder
    # Relative to project root (since we run with python -m from root)
    output_dir = "benchmarking_ai/ml_v4/model_artifacts"
    if not os.path.exists(output_dir):
        os.makedirs(output_dir)
    
    # 2. Train Cluster Engine
    ce = ClusterEngine()
    ce.fit(d_matrix, profiles)
    ce.save_model(f"{output_dir}/v4")
    print("✓ Cluster Engine trained and saved.")
    
    # 3. Train Strategic Gap Analyzer
    sga = StrategicGapAnalyzer()
    sga.fit(d_matrix)
    sga.save_model(f"{output_dir}/v4")
    print("✓ Strategic Gap Analyzer trained and saved.")
    
    # 4. Train Roadmap Generator
    rg = RoadmapGenerator()
    rg.fit(d_matrix, q_matrix)
    rg.save_model(f"{output_dir}/v4")
    print("✓ Roadmap Generator trained and saved.")
    
    print("✅ All ML v4 models successfully trained.")

if __name__ == "__main__":
    train_and_save()
