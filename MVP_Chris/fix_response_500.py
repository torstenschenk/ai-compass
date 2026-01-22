
import pandas as pd
import random
import os

def fix_response_500():
    # Use absolute path relative to this script location
    script_dir = os.path.dirname(os.path.abspath(__file__))
    base_dir = os.path.join(script_dir, "Tables")
    items_path = os.path.join(base_dir, "response_items.csv")
    answers_path = os.path.join(base_dir, "answers.csv")

    # Load Answers to get valid IDs
    answers_df = pd.read_csv(answers_path)
    
    # Load Items
    items_df = pd.read_csv(items_path)
    
    # Remove existing 500 if present
    if 500 in items_df['response_id'].values:
        print("Removing existing items for Response 500...")
        items_df = items_df[items_df['response_id'] != 500]
        # We need to save this intermediate state or just append to it in memory
        # Better to just use in-memory df and concat
        # Note: items_path will be overwritten
    
    print("Generating items for Response 500...")
    
    # Simulate a high-maturity company (mostly 4s and 5s)
    # Filter answers by level 4 or 5 where possible
    
    new_rows = []
    next_item_id = items_df['item_id'].max() + 1
    
    for q_id in range(1, 34): # 33 questions
        valid_answers = answers_df[answers_df['question_id'] == q_id]
        
        if valid_answers.empty:
            continue
            
        # Pick a high scoring answer (level 4 or 5)
        high_answers = valid_answers[valid_answers['answer_level'] >= 4]
        if not high_answers.empty:
            selected = high_answers.sample(1).iloc[0]
        else:
            selected = valid_answers.sample(1).iloc[0]
            
        # Create row
        new_row = {
            'item_id': next_item_id,
            'response_id': 500,
            'question_id': q_id,
            'answers': f"[{selected['answer_id']}]"
        }
        new_rows.append(new_row)
        next_item_id += 1
        
    # Concat
    new_items_df = pd.DataFrame(new_rows)
    final_df = pd.concat([items_df, new_items_df], ignore_index=True)
    
    # Save
    final_df.to_csv(items_path, index=False)
    
    print(f"Regenerated {len(new_rows)} items for Response 500.")

if __name__ == "__main__":
    fix_response_500()
