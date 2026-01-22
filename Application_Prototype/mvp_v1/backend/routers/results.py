import sys
import os
import pandas as pd
import numpy as np
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from database import get_db
from models import Response, ResponseItem, Company, Question, Answer, Dimension, ClusterProfile
from sqlalchemy import func

# Add project root to sys.path to allow importing from benchmarking_ai
# results.py is in backend/routers/ -> ../../../ is Application_Prototype -> ../../../../ is ai-compass (Root)
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), "../../../../")))

try:
    from benchmarking_ai.ml_v5.inference import InferenceEngine
    # Initialize Engine Global (Lazy load or at startup)
    # Note: This loads models into memory once
    inference_engine = InferenceEngine()
    print("ML Inference Engine Loaded Successfully")
except ImportError as e:
    print(f"Failed to import InferenceEngine: {e}")
    inference_engine = None

router = APIRouter()

@router.get("/{response_id}/results")
def get_results(response_id: int, db: Session = Depends(get_db)):
    """
    Retrieve full analysis results.
    1. Fetch Session Data
    2. Score Dimensions (Replicating DataPipeline logic)
    3. Run ML Inference
    4. Return JSON
    """
    try:
        if not inference_engine or not inference_engine.loaded:
             raise HTTPException(status_code=503, detail="AI Analysis Engine is unavailable.")

        # 1. Fetch Data
        response = db.query(Response).filter(Response.response_id == response_id).first()
        if not response:
            raise HTTPException(status_code=404, detail="Response not found")
        
        company = db.query(Company).filter(Company.company_id == response.company_id).first()
        
        items = db.query(ResponseItem).filter(ResponseItem.response_id == response_id).all()
        if not items:
             raise HTTPException(status_code=400, detail="No answers found for this response")

        # Fetch Reference Data
        questions_all = db.query(Question).all()
        dimensions_all = db.query(Dimension).all()
        answers_all = db.query(Answer).all()

        # 2. Convert to DataFrame
        rows_items = [{"question_id": i.question_id, "answers": i.answers} for i in items]
        df_items = pd.DataFrame(rows_items)
        
        # Include tactical_theme (header)
        rows_questions = [{"question_id": q.question_id, "dimension_id": q.dimension_id, "question_weight": q.weight, "question_type": q.type, "question_text": q.question_text, "tactical_theme": q.header} for q in questions_all]
        df_questions = pd.DataFrame(rows_questions)

        rows_dims = [{"dimension_id": d.dimension_id, "dimension_name": d.dimension_name} for d in dimensions_all]
        df_dims = pd.DataFrame(rows_dims)

        rows_answers = [{"answer_id": a.answer_id, "question_id": a.question_id, "answer_weight": a.answer_weight} for a in answers_all]
        df_answers_ref = pd.DataFrame(rows_answers)

        # 3. Scoring Logic
        df_items_exploded = df_items.explode('answers')
        df_items_exploded = df_items_exploded.rename(columns={'answers': 'answer_id'})
        df_items_exploded['answer_id'] = df_items_exploded['answer_id'].astype(float).fillna(0).astype(int)

        full_df = df_items_exploded.merge(df_answers_ref, on=['answer_id', 'question_id'], how='left')
        full_df = full_df.merge(df_questions, on='question_id', how='left')
        full_df = full_df.merge(df_dims, on='dimension_id', how='left')
        
        ans_stats = df_answers_ref.groupby('question_id').agg(
            total_possible_weight=('answer_weight', 'sum'),
            max_possible_weight=('answer_weight', 'max')
        ).reset_index()
        
        full_df = full_df.merge(ans_stats, on='question_id', how='left')

        # FIX: Added tactical_theme to groupby key to preserve it
        grouped_q = full_df.groupby([
            'question_id', 'dimension_name', 'question_weight', 'question_type', 
            'total_possible_weight', 'max_possible_weight', 'question_text', 'tactical_theme'
        ])['answer_weight'].sum().reset_index().rename(columns={'answer_weight': 'sum_selected_weight'})

        def calculate_question_score(row):
            if row['question_type'] == 'Checklist':
                total_w = row['total_possible_weight']
                ratio = row['sum_selected_weight'] / total_w if total_w > 0 else 0
            else:
                max_w = row['max_possible_weight']
                ratio = row['sum_selected_weight'] / max_w if max_w > 0 else 0
            return (ratio * row['question_weight']) / 100

        grouped_q['question_score_contrib'] = grouped_q.apply(calculate_question_score, axis=1)

        dim_groups = grouped_q.groupby('dimension_name')
        dim_results = dim_groups.apply(
            lambda x: (x['question_score_contrib'].sum() / (x['question_weight'].sum() / 100)) * 4 + 1 
            if x['question_weight'].sum() > 0 else 1.0
        )
        
        if 'General Psychology' in dim_results.index:
            dim_results = dim_results.drop('General Psychology')

        grouped_q['score_1to5'] = (grouped_q['question_score_contrib'] / (grouped_q['question_weight'] / 100)) * 4 + 1
        grouped_q['score_1to5'] = grouped_q['score_1to5'].fillna(1.0)
        
        # SANITIZATION
        grouped_q['tactical_theme'] = grouped_q['tactical_theme'].fillna("")
        grouped_q['question_text'] = grouped_q['question_text'].fillna("")
        grouped_q['question_type'] = grouped_q['question_type'].fillna("")
        
        # 5. Run Inference
        analysis = inference_engine.run_analysis(dim_results, grouped_q, company_industry=company.industry)

        if "error" in analysis:
             raise HTTPException(status_code=500, detail=analysis["error"])

        # 6. Construct Response
        final_result = {
            "company": {
                "name": company.company_name,
                "industry": company.industry,
                "size": company.number_of_employees
            },
            "overall_score": round(dim_results.mean(), 2),
            "dimension_scores": dim_results.round(2).to_dict(),
            "cluster": analysis.get("cluster"),
            "strategic_gaps": analysis.get("strategic_findings"),
            "roadmap": analysis.get("roadmap"),
            "executive_briefing": analysis.get("executive_briefing"),
            "percentile": analysis.get("percentile")
        }
        
        return final_result

    except Exception as e:
        import traceback
        traceback.print_exc()
        print(f"CRITICAL ERROR in get_results: {e}")
        from fastapi.responses import JSONResponse
        return JSONResponse(status_code=500, content={"detail": f"Debug Error: {str(e)}"})

@router.get("/{response_id}/pdf")
def generate_pdf(response_id: int, db: Session = Depends(get_db)):
    """
    Generate and download PDF report.
    """
    return {"message": "PDF generation placeholder", "response_id": response_id}
