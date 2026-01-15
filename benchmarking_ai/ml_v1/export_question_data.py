
import os
import pandas as pd
import psycopg2
from psycopg2 import extras
from dotenv import load_dotenv
import json

load_dotenv()

def get_question_data():
    conn = psycopg2.connect(
        user=os.getenv("user"),
        password=os.getenv("password"),
        host=os.getenv("host"),
        port=os.getenv("port"),
        dbname=os.getenv("dbname")
    )
    
    cur = conn.cursor(cursor_factory=extras.RealDictCursor)
    
    cur.execute("SELECT question_id, type, weight FROM questions")
    questions = cur.fetchall()
    
    cur.execute("SELECT question_id, answer_weight FROM answers")
    answers = cur.fetchall()
    
    ans_df = pd.DataFrame(answers)
    
    results = []
    for q in questions:
        q_ans = ans_df[ans_df['question_id'] == q['question_id']]
        qid = q['question_id']
        qtype = q['type']
        qweight = float(q['weight'])
        
        if qtype == 'Checklist':
            total_ans_w = float(q_ans['answer_weight'].sum())
            max_ans_w = float(q_ans['answer_weight'].max()) if not q_ans.empty else 0.0
            results.append({
                'id': qid,
                'type': qtype,
                'weight': qweight,
                'total_ans_weight': total_ans_w,
                'max_ans_weight': max_ans_w
            })
        else:
            max_ans_w = float(q_ans['answer_weight'].max()) if not q_ans.empty else 0.0
            results.append({
                'id': qid,
                'type': qtype,
                'weight': qweight,
                'max_ans_weight': max_ans_w
            })
            
    print(json.dumps(results, indent=2))
    
    cur.close()
    conn.close()

if __name__ == "__main__":
    get_question_data()
