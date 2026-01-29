import sys
import os
import pandas as pd
import numpy as np
from fastapi import APIRouter, HTTPException
from fastapi import Response as FastAPIResponse
from services.pdf_service import PDFService
from services.session_store import session_store
from services.questionnaire_service import get_all_questions, get_all_dimensions

# Add project root to sys.path
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), "../../../../")))

try:
    from benchmarking_ai.ml_v5.inference import InferenceEngine
    # Initialize Engine Global
    inference_engine = InferenceEngine()
    if inference_engine and inference_engine.loaded:
        print("ML Inference Engine Loaded Successfully")
    else:
        print(f"ML Inference Engine failed to internal-load. Status: {inference_engine.loaded if inference_engine else 'None'}")
except Exception as e:
    print(f"CRITICAL ERROR: Failed to initialize InferenceEngine module: {e}")
    import traceback
    traceback.print_exc()
    inference_engine = None

router = APIRouter()

@router.get("/{response_id}/results")
def get_results(response_id: int):
    """
    Retrieve full analysis results from JSON store.
    """
    try:
        if not inference_engine or not inference_engine.loaded:
             err = inference_engine.last_error if inference_engine else "Module not initialized"
             print(f"Warning: ML Engine not loaded. Status: {inference_engine.loaded if inference_engine else 'None'}. Error: {err}")
             # raise HTTPException(status_code=503, detail="AI Analysis Engine is unavailable.")

        # 1. Fetch Assessment Data from Session Store
        assessment = session_store.get_assessment(response_id)
        if not assessment:
            raise HTTPException(status_code=404, detail="Response not found")
        
        company = assessment["company"]
        items = assessment["items"] # List of dicts {question_id, answers: []}
        
        if not items:
             raise HTTPException(status_code=400, detail="No answers found for this response")

        # Fetch Reference Data from Service (Static JSON)
        questions_all = get_all_questions()
        dimensions_all = get_all_dimensions()
        
        # Flatten answers reference from questions structure
        answers_all = []
        for q in questions_all:
             q_id = q.get("question_id")
             for a in q.get("answers", []):
                 a_copy = a.copy()
                 a_copy["question_id"] = q_id
                 answers_all.append(a_copy)

        # 2. Convert to DataFrame
        # items is list of dicts: {'item_id': 0, 'response_id': 1, 'question_id': 1, 'answers': [101]}
        rows_items = []
        for i in items:
            if isinstance(i, dict) and "question_id" in i:
                rows_items.append({"question_id": i["question_id"], "answers": i.get("answers") or []})
        
        if not rows_items:
             raise HTTPException(status_code=400, detail="No valid answers found for this response")
             
        df_items = pd.DataFrame(rows_items)
        df_items['question_id'] = df_items['question_id'].astype(int)
        
        # Questions
        rows_questions = [{
            "question_id": q.get("question_id"), 
            "dimension_id": q.get("dimension_id"), 
            "question_weight": q.get("weight", 1.0), 
            "question_type": q.get("type"), 
            "question_text": q.get("question_text"), 
            "tactical_theme": q.get("header")
        } for q in questions_all if q.get("question_id") is not None]
        df_questions = pd.DataFrame(rows_questions)
        df_questions['question_id'] = df_questions['question_id'].astype(int)

        # Dimensions
        rows_dims = [{"dimension_id": d.get("dimension_id"), "dimension_name": d.get("dimension_name")} for d in dimensions_all]
        df_dims = pd.DataFrame(rows_dims)

        # Answers Reference
        rows_answers = [{
            "answer_id": a.get("answer_id"), 
            "question_id": a.get("question_id"), 
            "answer_weight": a.get("answer_weight")
        } for a in answers_all]
        df_answers_ref = pd.DataFrame(rows_answers)
        df_answers_ref['question_id'] = df_answers_ref['question_id'].fillna(0).astype(int)
        df_answers_ref['answer_id'] = df_answers_ref['answer_id'].fillna(0).astype(int)

        # 3. Merging and Scoring Logic
        # Ensure ALL questions are present (right merge from df_questions)
        df_items_all = df_questions.merge(df_items, on='question_id', how='left')
        
        # Preserve skipped questions (empty answers) by filling with [0] so explode doesn't drop them
        df_items_all['answers'] = df_items_all['answers'].apply(lambda x: x if isinstance(x, list) and len(x) > 0 else [0])
        
        df_items_exploded = df_items_all.explode('answers')
        df_items_exploded = df_items_exploded.rename(columns={'answers': 'answer_id'})
        df_items_exploded['answer_id'] = df_items_exploded['answer_id'].astype(float).fillna(0).astype(int)

        # Merge with answer weights
        full_df = df_items_exploded.merge(df_answers_ref, on=['answer_id', 'question_id'], how='left')
        
        # Merge with dimension names
        full_df = full_df.merge(df_dims, on='dimension_id', how='left')
        
        # Calculate stats per question
        ans_stats = df_answers_ref.groupby('question_id').agg(
            total_possible_weight=('answer_weight', 'sum'),
            max_possible_weight=('answer_weight', 'max')
        ).reset_index()
        ans_stats['question_id'] = ans_stats['question_id'].astype(int)
        
        full_df = full_df.merge(ans_stats, on='question_id', how='left')

        # SANITIZATION
        full_df['answer_weight'] = full_df['answer_weight'].fillna(0)
        full_df.fillna({
            'dimension_name': 'Unknown Dimension',
            'question_text': 'Unknown Question',
            'tactical_theme': 'General',
            'question_type': 'Slider',
            'question_weight': 1.0,
            'total_possible_weight': 1.0,
            'max_possible_weight': 1.0
        }, inplace=True)

        # Group by question to get total selected weight
        grouped_q = full_df.groupby([
            'question_id', 'dimension_name', 'question_weight', 'question_type', 
            'total_possible_weight', 'max_possible_weight', 'question_text', 'tactical_theme'
        ])['answer_weight'].sum().reset_index().rename(columns={'answer_weight': 'sum_selected_weight'})

        def calculate_question_score(row):
            if str(row['question_type']).lower() == 'checklist':
                total_w = row['total_possible_weight']
                ratio = row['sum_selected_weight'] / total_w if total_w > 0 else 0
            else:
                max_w = row['max_possible_weight']
                ratio = row['sum_selected_weight'] / max_w if max_w > 0 else 0
            
            ratio = min(1.0, ratio)
            return (ratio * row['question_weight']) / 100

        grouped_q['question_score_contrib'] = grouped_q.apply(calculate_question_score, axis=1)

        dim_groups = grouped_q.groupby('dimension_name')
        dim_results = dim_groups.apply(
            lambda x: (x['question_score_contrib'].sum() / (x['question_weight'].sum() / 100)) * 4 + 1 
            if x['question_weight'].sum() > 0 else 1.0
        )
        
        # Standardize Dimensions
        all_dims = sorted(df_dims['dimension_name'].unique().tolist())
        expected_dims = [d for d in all_dims if d != 'General Psychology']
        
        dim_results = dim_results.reindex(expected_dims, fill_value=1.0)

        # Recalculate per-question score for gap analysis (1-5 scale)
        # Using a safer calculation
        def get_1to5(row):
            max_c = row['question_weight'] / 100
            if max_c > 0:
                return (row['question_score_contrib'] / max_c) * 4 + 1
            return 1.0

        grouped_q['score_1to5'] = grouped_q.apply(get_1to5, axis=1)
        
        grouped_q['tactical_theme'] = grouped_q['tactical_theme'].fillna("")
        grouped_q['question_text'] = grouped_q['question_text'].fillna("")
        grouped_q['question_type'] = grouped_q['question_type'].fillna("")

        # Filter out General Psychology
        grouped_q_final = grouped_q[grouped_q['dimension_name'] != 'General Psychology'].copy()

        # 5. Run Inference
        company_industry = company.get("industry", "Technology")
        
        if inference_engine and inference_engine.loaded:
            try:
                analysis = inference_engine.run_analysis(dim_results, grouped_q_final, company_industry=company_industry)
            except Exception as e:
                print(f"ML Analysis Engine Exception: {e}")
                import traceback
                traceback.print_exc()
                analysis = {"error": f"Internal Engine Error: {str(e)}"}
        else:
            # Fallback mock analysis
            print("Using fallback mock analysis due to Engine failure")
            analysis = {
                "cluster": {"cluster_name": "Traditionalist", "description": "Analysis unavailable."},
                "strategic_findings": [],
                "roadmap": {},
                "executive_briefing": "Analysis unavailable due to system error.",
                "percentile": {"percentage": 50, "industry": company_industry},
                "benchmark_scores": {}
            }

        if "error" in analysis:
             print(f"Inference Application Error: {analysis['error']}")
             # We still return final_result but with mock data or empty fields
             if not analysis.get("cluster"):
                 analysis["cluster"] = {"cluster_name": "Incomplete Data", "description": "Assessment could not be fully analyzed."}


        # 6. Construct Response
        final_result = {
            "company": {
                "name": company.get("company_name"),
                "industry": company.get("industry"),
                "size": company.get("number_of_employees")
            },
            "overall_score": round(dim_results.mean(), 2),
            "dimension_scores": dim_results.round(2).to_dict(),
            "cluster": analysis.get("cluster"),
            "strategic_gaps": analysis.get("strategic_findings"),
            "roadmap": analysis.get("roadmap"),
            "executive_briefing": analysis.get("executive_briefing"),
            "percentile": analysis.get("percentile"),
            "benchmark_scores": analysis.get("benchmark_scores")
        }
        
        return final_result

    except Exception as e:
        import traceback
        traceback.print_exc()
        print(f"CRITICAL ERROR in get_results: {e}")
        from fastapi.responses import JSONResponse
        return JSONResponse(status_code=500, content={"detail": f"Debug Error: {str(e)}"})


@router.get("/{response_id}/pdf")
def generate_pdf(response_id: int):
    """
    Generate and download PDF report.
    """
    try:
        results_data = get_results(response_id)
        
        if hasattr(results_data, 'status_code') and results_data.status_code >= 400:
             raise HTTPException(status_code=results_data.status_code, detail="Could not fetch results data")

        pdf_service = PDFService()
        pdf_bytes = pdf_service.generate_pdf(results_data)
        
        return FastAPIResponse(
            content=pdf_bytes, 
            media_type="application/pdf", 
            headers={"Content-Disposition": f"attachment; filename=ai_maturity_report_{response_id}.pdf"}
        )
    except Exception as e:
        print(f"PDF Gen Error: {e}")
        raise HTTPException(status_code=500, detail=str(e))
