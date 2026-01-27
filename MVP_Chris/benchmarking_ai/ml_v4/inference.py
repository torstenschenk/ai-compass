
import pandas as pd
import os
from benchmarking_ai.ml_v4.models import ClusterEngine, StrategicGapAnalyzer, RoadmapGenerator
from benchmarking_ai.ml_v4.utils import generate_narrative_template

class InferenceEngine:
    def __init__(self, artifacts_path="model_artifacts/v4"):
        # Resolve absolute path relative to this file
        base_dir = os.path.dirname(os.path.abspath(__file__))
        path = os.path.join(base_dir, artifacts_path)
        
        # Strip extension or prefix logic is handled in load_model usually, 
        # but here we passed "model_artifacts/v4" so models append their suffixes.
        # But wait, load_model takes 'path_prefix'.
        # We need to ensure we pass the right prefix.
        
        self.ce = ClusterEngine()
        self.sga = StrategicGapAnalyzer()
        self.rg = RoadmapGenerator()
        
        try:
            self.ce.load_model(path)
            self.sga.load_model(path)
            self.rg.load_model(path)
            self.loaded = True
        except Exception as e:
            print(f"Warning: Models not loaded. {e}")
            self.loaded = False

    def run_analysis(self, company_dim_series, company_question_df):
        """
        Runs full analysis for a single company.
        company_dim_series: pd.Series of dimension scores.
        company_question_df: pd.DataFrame of question details.
        """
        if not self.loaded:
            return {"error": "Models not loaded"}
        
        # 1. Cluster Prediction
        # Series to DataFrame (row) for scaler
        df_input = company_dim_series.to_frame().T 
        c_ids, c_names, coords = self.ce.predict(df_input)
        
        cluster_info = {
            "cluster_id": int(c_ids[0]),
            "cluster_name": c_names[0],
            "coordinates": coords[0].tolist()
        }
        
        # 2. Strategic Gap Analysis
        findings = self.sga.analyze(company_dim_series, company_question_df)
        narrative = self.sga.synthesize_narrative(findings, company_dim_series)
        
        # 3. Roadmap Generation
        roadmap = self.rg.generate(
            company_id=None, # Not strictly needed if internal logic uses vector search on series
            company_dim_series=company_dim_series, 
            company_question_df=company_question_df,
            strategic_gaps=findings
        )
        briefing = self.rg.synthesize_briefing(roadmap)
        
        return {
            "cluster": cluster_info,
            "strategic_findings": findings,
            "executive_briefing": narrative,
            "roadmap": roadmap,
            "roadmap_briefing": briefing
        }

if __name__ == "__main__":
    # Test execution
    print("Inference Engine module.")
