import json
import os
import sys

# Ensure backend path is set so we can import models/database
sys.path.append(os.path.join(os.getcwd(), 'backend'))

from database import SessionLocal
from models.question import Question, Answer
from models.dimension import Dimension
from models.response import ClusterProfile

def export_data():
    db = SessionLocal()
    try:
        print("Exporting data from database...")
        
        # 1. Dimensions
        dimensions = db.query(Dimension).all()
        dim_data = [
            {
                "dimension_id": d.dimension_id,
                "dimension_name": d.dimension_name,
                "dimension_weight": d.dimension_weight
            } 
            for d in dimensions
        ]
        
        # 2. Questions & Answers
        questions = db.query(Question).all() 
        # Note: We need to join with Dimension to get dimension_name since it's used in the schema
        
        q_data_list = []
        for q in questions:
            # Fetch answers for this question
            answers = db.query(Answer).filter(Answer.question_id == q.question_id).all()
            ans_data = [
                {
                    "answer_id": a.answer_id,
                    "answer_text": a.answer_text,
                    "answer_level": a.answer_level,
                    "answer_weight": a.answer_weight
                }
                for a in answers
            ]
            
            q_dict = {
                "question_id": q.question_id,
                "dimension_id": q.dimension_id, 
                "dimension_name": q.dimension_name, # Handles relationship lookup
                "header": q.header,
                "question_text": q.question_text,
                "type": q.type,
                "weight": q.weight,
                "optional": q.optional,
                "answers": ans_data
            }
            q_data_list.append(q_dict)

        # 3. Cluster Profiles
        clusters = db.query(ClusterProfile).all()
        cluster_data = [
            {
                "cluster_id": c.cluster_id,
                "cluster_name": c.cluster_name,
                "score_min": c.score_min,
                "score_max": c.score_max
            }
            for c in clusters
        ]
        
        # SAVE TO FILES
        output_dir = os.path.join(os.getcwd(), 'backend', 'data')
        os.makedirs(output_dir, exist_ok=True)
        
        with open(os.path.join(output_dir, 'dimensions.json'), 'w') as f:
            json.dump(dim_data, f, indent=4)
            
        with open(os.path.join(output_dir, 'questions.json'), 'w') as f:
            json.dump(q_data_list, f, indent=4)
            
        with open(os.path.join(output_dir, 'clusters.json'), 'w') as f:
            json.dump(cluster_data, f, indent=4)
            
        print(f"Export successful. Files saved to {output_dir}")
        print(f"- Dimensions: {len(dim_data)}")
        print(f"- Questions: {len(q_data_list)}")
        print(f"- Clusters: {len(cluster_data)}")
        
    except Exception as e:
        print(f"Export failed: {e}")
        import traceback
        traceback.print_exc()
    finally:
        db.close()

if __name__ == "__main__":
    export_data()
