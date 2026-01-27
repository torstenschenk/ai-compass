from core.db.csv_db import csv_db
from core.api.schemas import ResponseRead, DimensionScore, ClusterProfileRead, StrategicGapAnalysis, StrategicFinding
from benchmarking_ai.ml_v5.inference import InferenceEngine
import pandas as pd
import json
import base64
from datetime import datetime
import random

# Initialize ML Engine
ml_engine = InferenceEngine()

def generate_token(response_id):
    return base64.b64encode(str(response_id).encode()).decode()

async def create_new_response(company_data: dict):
    # 1. Create Company
    new_company = {
        "company_name": company_data.get("company_name"),
        "industry": company_data.get("industry"),
        "website": company_data.get("website"),
        "number_of_employees": company_data.get("number_of_employees"),
        "city": company_data.get("city"),
        "email": company_data.get("email")
    }
    company_id = await csv_db.add_record("companies", new_company)

    # 2. Create Response
    new_response = {
        "company_id": company_id,
        "created_at": datetime.utcnow().isoformat(),
        "total_score": None,
        "cluster_id": None,
        "cluster_id": None,
        "ab_group": 'B' # Force Group B for MVP Demo
    }
    response_id = await csv_db.add_record("responses", new_response)
    
    token = generate_token(response_id)
    return {
        "response_id": response_id,
        "access_token": token
    }

async def save_response_items(response_id: int, items: list):
    # Check if response exists
    resp = await csv_db.get_by_id("responses", "response_id", response_id)
    if not resp:
        return False

    # For each item, update or add
    for item in items:
        q_id = item['question_id']
        ans_ids = item['answer_ids']
        
        # Check if already exists in CSV
        df_items = csv_db.read_table("response_items")
        if not df_items.empty:
            mask = (df_items['response_id'].astype(str) == str(response_id)) & (df_items['question_id'].astype(str) == str(q_id))
            if mask.any():
                idx = df_items[mask].index[0]
                df_items.at[idx, 'answers'] = ans_ids
                csv_db.save_table("response_items", df_items)
                continue
        
        # Add new
        new_item = {
            "response_id": response_id,
            "question_id": q_id,
            "answers": ans_ids
        }
        await csv_db.add_record("response_items", new_item)
    
    return True

async def calculate_response_metrics(response_id: int):
    # 1. Load DataFrames
    items_df = csv_db.read_table("response_items")
    questions_df = csv_db.read_table("questions")
    dims_df = csv_db.read_table("dimensions")
    answers_df = csv_db.read_table("answers")
    
    # Filter items for this response
    items = items_df[items_df['response_id'].astype(str) == str(response_id)]
    if items.empty:
        return None, None, 0.0

    # 2. Join and Process
    question_rows = []
    
    # Maps for easy lookup
    q_map = questions_df.set_index('question_id').to_dict('index')
    dim_map = dims_df.set_index('dimension_id').to_dict('index')
    
    for _, item in items.iterrows():
        q_id = item['question_id']
        if q_id not in q_map: continue
        q = q_map[q_id]
        
        # Calculate selected weight
        selected_weight = 0.0
        selected_ans_ids = item['answers']
        
        # Parse properly if string (from CSV)
        if isinstance(selected_ans_ids, str):
            try:
                selected_ans_ids = json.loads(selected_ans_ids)
            except:
                selected_ans_ids = []
        
        # Ensure it's a list
        if not isinstance(selected_ans_ids, list):
            selected_ans_ids = []

        for aid in selected_ans_ids:
            a_match = answers_df[answers_df['answer_id'] == aid]
            if not a_match.empty:
                selected_weight += a_match.iloc[0]['answer_weight']

        # Get max/total weight for question
        q_answers = answers_df[answers_df['question_id'] == q_id]
        if q_answers.empty: continue
        
        if q['type'] == 'Checklist':
             total_possible = q_answers['answer_weight'].sum()
             ratio = selected_weight / total_possible if total_possible > 0 else 0
        else:
             max_possible = q_answers['answer_weight'].max()
             ratio = selected_weight / max_possible if max_possible > 0 else 0
        
        question_rows.append({
            'question_id': q_id,
            'question_text': q['question_text'],
            'question_weight': q['weight'],
            'question_type': q['type'],
            'tactical_theme': q['header'],
            'dimension_id': q['dimension_id'],
            'dimension_name': dim_map[q['dimension_id']]['dimension_name'] if q['dimension_id'] in dim_map else "Unknown",
            'ratio': ratio,
            'score_1to5': ratio * 4 + 1
        })
        
    df = pd.DataFrame(question_rows)
    if df.empty:
        return None, None, 0.0

    # 3. Aggregate Dimensions
    dim_scores = {}
    for d_name, group in df.groupby('dimension_name'):
        w_sum = group['question_weight'].sum()
        if w_sum > 0:
            weighted_ratio = (group['ratio'] * group['question_weight']).sum() / w_sum
            d_score = weighted_ratio * 4 + 1
        else:
            d_score = 1.0
        dim_scores[d_name] = d_score
        
    # 4. Overall Score
    overall_score = 0
    total_dim_weight = 0
    for _, d in dims_df.iterrows():
        d_name = d['dimension_name']
        d_weight = d['dimension_weight']
        d_score = dim_scores.get(d_name, 1.0)
        norm_score = (d_score - 1) / 4 * 100
        overall_score += norm_score * d_weight
        total_dim_weight += d_weight
        
    final_total_score = overall_score / total_dim_weight if total_dim_weight > 0 else 0
    return pd.Series(dim_scores), df, final_total_score


async def calculate_and_complete_response(response_id: int):
    # Calculate Metrics
    dim_series, question_df, total_score = await calculate_response_metrics(response_id)
    if dim_series is None:
        return None

    # Get Response
    response = await csv_db.get_by_id("responses", "response_id", response_id)
    
    # Run ML Inference (Only if Group B)
    cluster_id = 1
    if response.get("ab_group") == 'B':
        analysis = ml_engine.run_analysis(dim_series, question_df)
        if "cluster" in analysis:
            cluster_id = analysis["cluster"].get("cluster_id", 1)
    
    # Update Response in CSV
    await csv_db.update_record("responses", "response_id", response_id, {
        "total_score": str(round(total_score, 1)),
        "cluster_id": cluster_id
    })
    
    return {"response_id": response_id, "status": "completed", "total_score": total_score}

async def calculate_industry_benchmark(industry: str):
    # 1. Find all companies in this industry
    companies_df = csv_db.read_table("companies")
    if companies_df.empty:
        return {}
    
    # robust string matching
    target_industry = str(industry).strip().lower()
    companies = companies_df[companies_df['industry'].astype(str).str.strip().str.lower() == target_industry]
    company_ids = companies['company_id'].tolist()
    
    if not company_ids:
        return {}

    # 2. Find their responses
    responses_df = csv_db.read_table("responses")
    target_responses = responses_df[responses_df['company_id'].isin(company_ids)]
    response_ids = target_responses['response_id'].tolist()
    
    if not response_ids:
        return {}
    
    # 3. Aggregate Dimension Scores
    agg_scores = {}
    count_scores = {}
    
    for rid in response_ids:
        # Reuse existing logic to get scores for this response
        # Note: robustly handling potential errors if a response is incomplete
        try:
            dim_series, _, _ = await calculate_response_metrics(rid)
            if dim_series is not None:
                for dim, score in dim_series.items():
                    agg_scores[dim] = agg_scores.get(dim, 0.0) + score
                    count_scores[dim] = count_scores.get(dim, 0) + 1
        except Exception as e:
            continue

    # 4. Calculate Averages
    averages = {}
    for dim, total in agg_scores.items():
        count = count_scores.get(dim, 1)
        if count > 0:
            averages[dim] = total / count
        else:
            averages[dim] = 1.0 # default
            
    return averages


async def get_response_summary(response_id: int):
    response = await csv_db.get_by_id("responses", "response_id", response_id)
    if not response:
        return None

    company = await csv_db.get_by_id("companies", "company_id", response['company_id'])
    cluster = await csv_db.get_by_id("cluster_profiles", "cluster_id", response['cluster_id']) if response.get('cluster_id') else None
    
    dimensions_df = csv_db.read_table("dimensions")
    res_dim_series, question_df, _ = await calculate_response_metrics(response_id)
    
    # Calculate Industry Benchmark
    industry = company.get('industry', 'Unknown') if company else "Unknown"
    industry_benchmarks = await calculate_industry_benchmark(industry)
    
    dim_scores = []
    for _, dim in dimensions_df.iterrows():
        d_name = dim['dimension_name']
        score_val = res_dim_series[d_name] if res_dim_series is not None and d_name in res_dim_series else 1.0
        
        # Get industry average, default to 1.0 or perhaps a "global average" if minimal data?
        # For now, default to 1.0 if no industry data
        ind_score = industry_benchmarks.get(d_name, 1.0)
        
        dim_scores.append(DimensionScore(
            dimension_id=dim['dimension_id'],
            dimension_name=d_name,
            score=round(float(score_val), 2),
            max_score=5.0,
            industry_score=round(float(ind_score), 2)
        ))

    # Determine if we should run ML analysis (Group B or missing group)
    ab_group = response.get("ab_group")
    should_run_ml = ab_group == 'B' or not ab_group or str(ab_group).strip() == ''

    roadmap_data = {}
    analysis = {} # Store analysis result for reuse

    if should_run_ml and res_dim_series is not None:
         analysis = ml_engine.run_analysis(res_dim_series, question_df)
         if "roadmap" in analysis:
             roadmap_data = analysis["roadmap"]

    # Process Strategic Gap Analysis
    strategic_gap_data = None
    if should_run_ml and res_dim_series is not None:
         if "strategic_findings" in analysis:
             findings_list = []
             for f in analysis["strategic_findings"]:
                 findings_list.append(StrategicFinding(
                     type=f.get('type'),
                     title=f.get('title'),
                     score=float(f.get('score', 0.0)),
                     context=f.get('context'),
                     dimension_name=f.get('dimension_name') or f.get('source_dim'),
                     tactical_theme=f.get('tactical_theme')
                 ))
             
             strategic_gap_data = StrategicGapAnalysis(
                 executive_briefing=analysis.get("executive_briefing", ""),
                 detailed_findings=findings_list
             )

    cluster_data = None
    
    # Priority 1: Use Cluster from ML Analysis (if available)
    if "cluster" in analysis and analysis["cluster"]:
        c = analysis["cluster"]
        c_id = c.get("cluster_id", 1)
        # Fetch full profile from DB to ensure we have description
        ml_cluster_profile = await csv_db.get_by_id("cluster_profiles", "cluster_id", c_id)
        
        if ml_cluster_profile:
            desc = ml_cluster_profile.get('description')
            if pd.isna(desc) or not desc:
                desc = "No description"
            
            cluster_data = ClusterProfileRead(
                cluster_id=int(c_id),
                name=ml_cluster_profile['cluster_name'],
                description=desc
            )
        else:
             # Fallback if DB lookup fails (unlikely)
             cluster_data = ClusterProfileRead(
                cluster_id=int(c_id),
                name=c.get("cluster_name", "Unknown"),
                description="No description available"
            )
    # Priority 2: Use Cluster from DB (if not overridden by ML)
    elif cluster:
        desc = cluster.get('description')
        if pd.isna(desc) or not desc:
            desc = "No description"
            
        cluster_data = ClusterProfileRead(
            cluster_id=cluster['cluster_id'],
            name=cluster['cluster_name'],
            description=desc
        )  
    
    return ResponseRead(
        id=response['response_id'],
        company_name=company['company_name'] if company else "Unknown",
        industry=company.get('industry', 'Unknown') if company else "Unknown",
        overall_score=float(response['total_score']) if response.get('total_score') else 0.0,
        dimension_scores=dim_scores,
        cluster=cluster_data,
        roadmap=roadmap_data,
        strategic_gap_analysis=strategic_gap_data,
        completed_at=response['created_at']
    )
