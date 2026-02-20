from typing import List, Optional
from services.questionnaire_service import get_question_map

def calculate_total_score(items_data: List[dict], db=None) -> float:
    """
    Calculates the total score based on scoring_methodology.md
    1. Calculate Question Scores (ratio of max/total possible weight)
    2. Calculate Dimension Scores (weighted average of ratios * 4 + 1)
    3. Total Score = average of dimension scores
    """
    if not items_data:
        return 0.0

    # 1. Fetch Question and Answer metadata from Service (In-Memory JSON)
    questions_map = get_question_map()
    
    # Calculate stats per question from reference data
    q_stats = {}
    for q_id, q_data in questions_map.items():
        answers = q_data.get("answers", [])
        weights = [a.get("answer_weight") for a in answers if a.get("answer_weight") is not None]
        q_stats[q_id] = {
            "total_weight": sum(weights),
            "max_weight": max(weights) if weights else 0
        }
    
    # {dimension_id: {"numerator": sum(ratio * qw), "denominator": sum(qw)}}
    dim_calcs = {}
    
    for item in items_data:
        q_id = item["question_id"]
        if q_id not in questions_map or q_id not in q_stats:
            continue
            
        q = questions_map[q_id]
        stats = q_stats[q_id]
        
        # Selected answer weights
        # item["answers"] is a list of answer_ids
        selected_ids = item["answers"]
        
        # Find selected weights from reference
        q_answers = q.get("answers", [])
        selected_weights = []
        for ans in q_answers:
             if ans.get("answer_id") in selected_ids:
                 w = ans.get("answer_weight")
                 if w is not None:
                     selected_weights.append(w)
                     
        sum_selected = sum(selected_weights)
        
        ratio = 0
        q_type = (q.get("type") or "").lower()
        
        if q_type == 'checklist':
            if stats["total_weight"] > 0:
                ratio = sum_selected / stats["total_weight"]
        else:
            if stats["max_weight"] > 0:
                ratio = sum_selected / stats["max_weight"]
        
        # Clamp ratio to 1.0
        ratio = min(1.0, ratio)
        
        # Question weight
        qw = q.get("weight", 1.0)
        dim_id = q.get("dimension_id", 0)
        
        if dim_id not in dim_calcs:
            dim_calcs[dim_id] = {"numerator": 0, "denominator": 0}
            
        dim_calcs[dim_id]["numerator"] += ratio * qw
        dim_calcs[dim_id]["denominator"] += qw

    # 2. Final dimension scores (1-5 scale)
    dimension_scores = []
    for d_id, calc in dim_calcs.items():
        if calc["denominator"] > 0:
            # Dimension_Mastery = SUM(ratio * weight) / SUM(weight)
            # Score = (Mastery * 4) + 1
            d_score = (calc["numerator"] / calc["denominator"]) * 4 + 1
            dimension_scores.append(d_score)
            
    if not dimension_scores:
        return 0.0
        
    # 3. Total Score is simple average of dimension scores
    total_score = sum(dimension_scores) / len(dimension_scores)
    return round(total_score, 2)
