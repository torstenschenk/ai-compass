"""
Production API endpoint for ML v5 AI Compass analysis.

This module provides the main API function that:
1. Accepts company_id and response_id
2. Loads trained ml_v5 models
3. Fetches company data from database
4. Generates comprehensive analysis
5. Returns JSON formatted for frontend consumption
"""

import os
import json
import psycopg2
from psycopg2 import extras
from dotenv import load_dotenv
import pandas as pd
import sys

# Add parent directory to path for imports
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from benchmarking_ai.ml_v5.models import ClusterEngine, StrategicGapAnalyzer, RoadmapGenerator

load_dotenv()


class AICompassAPI:
    """Main API class for AI Compass analysis."""
    
    def __init__(self, models_path="benchmarking_ai/ml_v5/model_artifacts/v5"):
        """Initialize API with trained models."""
        self.models_path = models_path
        self.cluster_engine = ClusterEngine()
        self.gap_analyzer = StrategicGapAnalyzer()
        self.roadmap_generator = RoadmapGenerator()
        
        # Load models
        self._load_models()
        
    def _load_models(self):
        """Load all trained models."""
        try:
            self.cluster_engine.load_model(self.models_path)
            self.gap_analyzer.load_model(self.models_path)
            self.roadmap_generator.load_model(self.models_path)
            print("Models loaded successfully")
        except Exception as e:
            print(f"Error loading models: {e}")
            raise
    
    def _get_db_connection(self):
        """Get database connection."""
        db_url = os.getenv("DATABASE_URL")
        if db_url:
            return psycopg2.connect(db_url)
        else:
            return psycopg2.connect(
                user=os.getenv("user"),
                password=os.getenv("password"),
                host=os.getenv("host"),
                port=os.getenv("port"),
                dbname=os.getenv("dbname")
            )
    
    def _fetch_company_data(self, company_id, response_id):
        """
        Fetch all required company data from database.
        Uses the data_pipeline for consistency.
        
        Args:
            company_id: Company ID
            response_id: Response ID
            
        Returns:
            dict with dimension_scores, question_data, and metadata
        """
        from benchmarking_ai.ml_v5.data_pipeline import DataPipeline
        
        # Use data_pipeline to get matrices
        dp = DataPipeline()
        dfs = dp.fetch_data()
        q_matrix, d_matrix, profiles, q_meta = dp.create_matrices(dfs)
        
        # Get company profile from database
        conn = self._get_db_connection()
        cur = conn.cursor(cursor_factory=extras.RealDictCursor)
        cur.execute("SELECT * FROM companies WHERE company_id = %s", (company_id,))
        company_profile = cur.fetchone()
        cur.close()
        conn.close()
        
        # Extract data for this specific company
        if company_id not in d_matrix.index:
            raise ValueError(f"Company ID {company_id} not found in dataset")
        
        dimension_scores = d_matrix.loc[company_id]
        
        # Get question-level data
        company_q_scores = q_matrix.loc[company_id].reset_index()
        company_q_scores.columns = ['question_id', 'score_1to5']
        question_data = company_q_scores.merge(q_meta, on='question_id', how='left')
        
        return {
            'company_profile': company_profile,
            'dimension_scores': dimension_scores,
            'question_data': question_data
        }
    
    def generate_analysis(self, company_id, response_id):
        """
        Generate complete AI Compass analysis for a company.
        
        Args:
            company_id: Company ID
            response_id: Response ID
            
        Returns:
            dict: JSON-formatted analysis ready for frontend
        """
        # Fetch company data
        data = self._fetch_company_data(company_id, response_id)
        
        # Calculate total maturity
        total_maturity = float(data['dimension_scores'].mean())
        company_industry = data['company_profile'].get('industry') if data['company_profile'] else None
        
        # 1. Cluster Analysis
        dim_df = data['dimension_scores'].to_frame().T
        cluster_ids, cluster_names, coords = self.cluster_engine.predict(dim_df)
        
        # Calculate industry percentile
        percentile_info = None
        if company_industry:
            percentile_info = self.cluster_engine.calculate_industry_percentile(
                total_maturity, company_industry
            )
        
        cluster_info = {
            "cluster_id": int(cluster_ids[0]),
            "cluster_name": cluster_names[0],
            "coordinates": {
                "x": float(coords[0][0]),
                "y": float(coords[0][1])
            }
        }
        
        # Add percentile to cluster info if available
        if percentile_info:
            cluster_info["industry_percentile"] = percentile_info
        
        # 2. Strategic Gap Analysis
        findings = self.gap_analyzer.analyze(
            data['dimension_scores'],
            data['question_data']
        )
        narrative = self.gap_analyzer.synthesize_narrative(
            findings,
            data['dimension_scores']
        )
        
        # 3. Roadmap Generation
        roadmap = self.roadmap_generator.generate(
            company_id=company_id,
            company_dim_series=data['dimension_scores'],
            company_question_df=data['question_data'],
            strategic_gaps=findings
        )
        briefing = self.roadmap_generator.synthesize_briefing(roadmap)
        
        # 4. Format for frontend
        return self._format_response(
            company_profile=data['company_profile'],
            dimension_scores=data['dimension_scores'],
            cluster_info=cluster_info,
            findings=findings,
            narrative=narrative,
            roadmap=roadmap,
            briefing=briefing,
            total_maturity=total_maturity
        )
    
    def _format_response(self, company_profile, dimension_scores, cluster_info, 
                        findings, narrative, roadmap, briefing, total_maturity):
        """Format analysis results as JSON for frontend."""
        
        # Format dimension scores
        dimension_scores_dict = {
            dim: float(score) for dim, score in dimension_scores.items()
        }
        
        # Use provided total maturity
        total_maturity_score = total_maturity
        
        # Format strategic findings
        formatted_findings = []
        for f in findings:
            formatted_findings.append({
                "type": f.get('type'),
                "title": f.get('title'),
                "severity_score": float(f.get('score', 0)),
                "context": f.get('context'),
                "dimension_name": f.get('dimension_name'),
                "tactical_theme": f.get('tactical_theme')
            })
        
        # Format roadmap with explanations
        formatted_roadmap = {}
        phase_names = {
            'Phase 1: Foundation': 'phase_1',
            'Phase 2: Implementation': 'phase_2',
            'Phase 3: Scale & Governance': 'phase_3'
        }
        
        for phase, items in roadmap.items():
            phase_key = phase_names.get(phase, phase.lower().replace(' ', '_'))
            formatted_items = []
            
            for item in items:
                formatted_item = {
                    "theme": item.get('theme'),
                    "source": item.get('source'),
                    "impact_score": float(item.get('impact', 0)),
                    "dimension": item.get('dimension'),
                    "explanation": item.get('explanation', '')
                }
                formatted_items.append(formatted_item)
            
            formatted_roadmap[phase_key] = {
                "name": phase.split(': ')[1] if ': ' in phase else phase,
                "description": "",  # Can be extracted from briefing if needed
                "recommendations": formatted_items
            }
        
        # Build final response
        response = {
            "status": "success",
            "meta": {
                "api_version": "v5.1",
                "model_version": "ml_v5",
                "company_id": company_profile.get('company_id') if company_profile else company_id
            },
            "data": {
                "company_profile": {
                    "company_id": company_profile.get('company_id') if company_profile else company_id,
                    "industry": company_profile.get('industry') if company_profile else None,
                    "size": company_profile.get('size') if company_profile else None
                },
                "assessment_results": {
                    "total_maturity_score": total_maturity_score,
                    "dimension_scores": dimension_scores_dict
                },
                "ai_compass_intelligence": {
                    "cluster_segment": cluster_info,
                    "strategic_gap_analysis": {
                        "executive_briefing": narrative,
                        "detailed_findings": formatted_findings
                    },
                    "transformation_roadmap": {
                        "briefing": briefing,
                        "phases": formatted_roadmap
                    }
                }
            }
        }
        
        return response


def analyze_company(company_id, response_id):
    """
    Main API function to analyze a company.
    
    Args:
        company_id: Company ID
        response_id: Response ID
        
    Returns:
        dict: JSON-formatted analysis
    """
    api = AICompassAPI()
    return api.generate_analysis(company_id, response_id)


if __name__ == "__main__":
    # Example usage
    result = analyze_company(company_id=46, response_id=46)
    print(json.dumps(result, indent=2))
