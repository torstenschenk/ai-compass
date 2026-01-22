from sqlalchemy.orm import Session
from models.question import Question, Answer
from typing import List

def calculate_total_score(items_data: List[dict], db: Session) -> float:
    """
    Calculates the total score based on scoring_methodology.md
    1. Calculate Question Scores (ratio of max/total possible weight)
    2. Calculate Dimension Scores (weighted average of ratios * 4 + 1)
    3. Total Score = average of dimension scores
    """
    if not items_data:
        return 0.0

    # 1. Fetch Question and Answer metadata
    q_ids = [item["question_id"] for item in items_data]
    questions = db.query(Question).filter(Question.question_id.in_(q_ids)).all()
    q_meta = {q.question_id: q for q in questions}
    
    # Fetch ALL answers for these questions to calculate totals/maxes
    all_answers = db.query(Answer).filter(Answer.question_id.in_(q_ids)).all()
    
    # Group answers by question
    ans_ref = {}
    for ans in all_answers:
        if ans.question_id not in ans_ref:
            ans_ref[ans.question_id] = []
        ans_ref[ans.question_id].append(ans)
        
    # Calculate stats per question
    q_stats = {}
    for q_id, answers in ans_ref.items():
        weights = [a.answer_weight for a in answers if a.answer_weight is not None]
        q_stats[q_id] = {
            "total_weight": sum(weights),
            "max_weight": max(weights) if weights else 0
        }
    
    # {dimension_id: {"numerator": sum(ratio * qw), "denominator": sum(qw)}}
    dim_calcs = {}
    
    for item in items_data:
        q_id = item["question_id"]
        if q_id not in q_meta or q_id not in q_stats:
            continue
            
        q = q_meta[q_id]
        stats = q_stats[q_id]
        
        # Selected answer weights
        selected_ids = item["answers"]
        selected_weights = [a.answer_weight for a in ans_ref.get(q_id, []) 
                           if a.answer_id in selected_ids and a.answer_weight is not None]
        sum_selected = sum(selected_weights)
        
        ratio = 0
        q_type = (q.type or "").lower()
        if q_type == 'checklist':
            if stats["total_weight"] > 0:
                ratio = sum_selected / stats["total_weight"]
        else:
            if stats["max_weight"] > 0:
                ratio = sum_selected / stats["max_weight"]
        
        # Clamp ratio to 1.0
        ratio = min(1.0, ratio)
        
        # Question weight (standardize to 1.0 if not defined, though usually it's like 3.5-5.0)
        qw = q.weight if q.weight is not None else 1.0
        
        if q.dimension_id not in dim_calcs:
            dim_calcs[q.dimension_id] = {"numerator": 0, "denominator": 0}
            
        dim_calcs[q.dimension_id]["numerator"] += ratio * qw
        dim_calcs[q.dimension_id]["denominator"] += qw

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
