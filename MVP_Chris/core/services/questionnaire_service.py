from core.db.csv_db import csv_db
import pandas as pd

async def get_full_questionnaire():
    # Read from CSVs via our adapter
    dimensions_raw = await csv_db.get_all("dimensions")
    questions_raw = await csv_db.get_all("questions")
    answers_raw = await csv_db.get_all("answers")
    
    # Transform to nested structure
    data = []
    
    # Sort dimensions by ID
    dimensions_sorted = sorted(dimensions_raw, key=lambda x: x['dimension_id'])
    
    for dim in dimensions_sorted:
        dim_id = dim['dimension_id']
        dim_data = {
            "id": dim_id,
            "title": dim['dimension_name'],
            "weight": dim['dimension_weight'],
            "questions": []
        }
        
        # Filter questions for this dimension
        dim_questions = [q for q in questions_raw if q['dimension_id'] == dim_id]
        sorted_questions = sorted(dim_questions, key=lambda q: q['question_id'])
        
        for q in sorted_questions:
            q_id = q['question_id']
            q_data = {
                "id": q_id,
                "text": q['question_text'],
                "header": q['header'],
                "type": q['type'],
                "weight": q['weight'],
                "optional": str(q['optional']).lower() == 'true',
                "answers": []
            }
            
            # Filter answers for this question
            q_answers = [a for a in answers_raw if a['question_id'] == q_id]
            sorted_answers = sorted(q_answers, key=lambda a: a['answer_id'])
            
            for a in sorted_answers:
                q_data["answers"].append({
                    "id": a['answer_id'],
                    "text": a['answer_text'],
                    "level": a['answer_level'],
                    "weight": a['answer_weight']
                })
            dim_data["questions"].append(q_data)
        data.append(dim_data)
        
    return data
