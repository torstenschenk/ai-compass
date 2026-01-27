
import os
import pandas as pd
import psycopg2
from psycopg2 import extras
from dotenv import load_dotenv

load_dotenv()

def inspect_weights():
    conn = psycopg2.connect(
        user=os.getenv("user"),
        password=os.getenv("password"),
        host=os.getenv("host"),
        port=os.getenv("port"),
        dbname=os.getenv("dbname")
    )
    
    cur = conn.cursor(cursor_factory=extras.RealDictCursor)
    
    # Fetch questions
    cur.execute("SELECT question_id, type, weight FROM questions")
    questions = pd.DataFrame(cur.fetchall())
    
    # Fetch answers
    cur.execute("SELECT question_id, answer_weight FROM answers")
    answers = pd.DataFrame(cur.fetchall())
    
    print(f"Total questions: {len(questions)}")
    print(f"Total answers: {len(answers)}")
    
    # Calculate stats per question
    checklist_stats = []
    other_stats = []
    
    for _, q in questions.iterrows():
        q_answers = answers[answers['question_id'] == q['question_id']]
        if q['type'] == 'Checklist':
            total_answer_weight = q_answers['answer_weight'].sum()
            checklist_stats.append({
                'id': q['question_id'],
                'q_weight': q['weight'],
                'total_ans_weight': total_answer_weight,
                'ans_count': len(q_answers)
            })
        else:
            max_answer_weight = q_answers['answer_weight'].max() if not q_answers.empty else 0
            other_stats.append({
                'id': q['question_id'],
                'type': q['type'],
                'q_weight': q['weight'],
                'max_ans_weight': max_answer_weight,
                'ans_count': len(q_answers)
            })
            
    print("\n--- CHECKLIST QUESTIONS ---")
    if checklist_stats:
        print(pd.DataFrame(checklist_stats).to_string())
    else:
        print("No checklist questions found.")
    
    print("\n--- OTHER QUESTIONS ---")
    if other_stats:
        print(pd.DataFrame(other_stats).to_string())
    else:
        print("No other questions found.")
    
    total_q_weight = questions['weight'].sum()
    print(f"\nTotal Question Weight: {total_q_weight}")
    
    cur.close()
    conn.close()

if __name__ == "__main__":
    inspect_weights()
