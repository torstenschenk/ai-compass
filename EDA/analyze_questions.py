import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import os
import sys
from fetch_data import fetch_all_data

# Force UTF-8 output
sys.stdout.reconfigure(encoding='utf-8')

sns.set_theme(style="whitegrid")
plt.rcParams['figure.figsize'] = (12, 6)

def analyze_questions(data):
    """Analyze question responses."""
    items = data['response_items']
    questions = data['questions']
    answers = data['answers']
    output_dir = 'EDA/plots'
    
    print(f"Analyzing {len(items)} response items...")
    
    # Create question map
    q_map = dict(zip(questions['question_id'], questions['question_text']))
    q_type_map = dict(zip(questions['question_id'], questions['type']))
    
    # Flatten items if needed? 
    # Items have 'answers' as array. We need to explode for counting frequencies.
    # Note: 'answers' column likely came as list from fetch_data (pandas handles pg arrays? usually needs help)
    # Check first item to see type
    sample_ans = items['answers'].iloc[0]
    if isinstance(sample_ans, str):
        # Need to parse if it's string "{1,2,3}"
        # fetch_data might not parse pg array automatically without register_adapter or specific pandas read
        pass 
        
    # Helper to parse PG array string "{1,2,3}" or [1,2,3]
    def parse_pg_array(val):
        if isinstance(val, list): return val
        if pd.isna(val): return []
        val = str(val).strip('{}')
        if not val: return []
        return [int(x) for x in val.split(',')]

    # Explode answers for frequency analysis
    items['answers_list'] = items['answers'].apply(parse_pg_array)
    exploded = items.explode('answers_list')
    exploded.rename(columns={'answers_list': 'answer_id'}, inplace=True)
    
    # Merge with answer text
    # numeric_only=True to avoid future warnings if needed, but here we merge on int key
    # Ensure answer_id is int
    exploded['answer_id'] = pd.to_numeric(exploded['answer_id'], errors='coerce')
    exploded.dropna(subset=['answer_id'], inplace=True)
    exploded['answer_id'] = exploded['answer_id'].astype(int)
    
    full_df = pd.merge(exploded, answers, on='answer_id')
    
    summary_file = open('EDA/questions_analysis_summary.txt', 'w')
    summary_file.write("QUESTION ANALYSIS SUMMARY\n")
    summary_file.write("=========================\n\n")

    # Analyze top 5 most interesting questions (or just loop a few different types)
    # Let's pick 1 from each type: Statement, Choice, Slider, Checklist
    
    types_to_sample = ['Statement', 'Choice', 'Slider', 'Checklist']
    
    for q_type in types_to_sample:
        # Find a question of this type
        sample_q_id = questions[questions['type'] == q_type].iloc[0]['question_id']
        question_text = q_map[sample_q_id]
        
        print(f"  Analyzing Q{sample_q_id} ({q_type})...")
        summary_file.write(f"--- Q{sample_q_id} ({q_type}) ---\n")
        summary_file.write(f"Text: {question_text}\n")
        
        # Filter for this question
        q_data = full_df[full_df['question_id_x'] == sample_q_id] # x from items, y from answers? items has question_id, answers has question_id
        # Actually items has question_id, answers has question_id. Merge suffix default _x _y
        # exploded has question_id (from items), answers has question_id (metadata)
        # We merged on answer_id.
        # Let's use the question_id from exploded (items)
        
        counts = q_data['answer_text'].value_counts()
        total_answers = counts.sum()
        
        summary_file.write(f"Total Selections: {total_answers}\n")
        summary_file.write("Answer Frequencies:\n")
        for ans, count in counts.items():
            pct = count / total_answers * 100
            summary_file.write(f"  - {ans}: {count} ({pct:.1f}%)\n")
        summary_file.write("\n")
        
        # Plot
        plt.figure(figsize=(10, 6))
        sns.barplot(x=counts.values, y=counts.index, palette='Blues_d')
        plt.title(f'Q{sample_q_id} Response Distribution ({q_type})')
        plt.xlabel('Count')
        plt.ylabel('Answer')
        plt.tight_layout()
        plt.savefig(os.path.join(output_dir, f'q{sample_q_id}_dist.png'))
        plt.close()
        print(f"  Saved q{sample_q_id}_dist.png")

    summary_file.close()
    print("  Saved questions_analysis_summary.txt")

if __name__ == "__main__":
    data = fetch_all_data()
    analyze_questions(data)
