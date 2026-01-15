import pandas as pd
import json

# Load CSV
df = pd.read_csv('AI_Compass_data_generation_2/assessment_data.csv')

# Get question columns (H to AN = indices 7 to 39)
question_cols = df.columns[7:40].tolist()

output = {
    'total_rows': len(df),
    'total_columns': len(df.columns),
    'question_columns_count': len(question_cols),
    'questions': []
}

# Analyze each question column
for i, col in enumerate(question_cols, start=1):
    unique_answers = df[col].dropna().unique()
    
    question_info = {
        'column_index': i + 6,  # H is 7 (0-indexed)
        'question_text': col,
        'unique_answer_count': len(unique_answers),
        'sample_answers': unique_answers[:5].tolist() if len(unique_answers) > 0 else []
    }
    
    output['questions'].append(question_info)

# Save to JSON
with open('csv_questions_analysis.json', 'w', encoding='utf-8') as f:
    json.dump(output, f, indent=2, ensure_ascii=False)

print(f"Analyzed {len(question_cols)} question columns")
print(f"Saved to csv_questions_analysis.json")

# Print first few questions
print("\nFirst 3 questions:")
for q in output['questions'][:3]:
    print(f"\nQ{q['column_index']}: {q['question_text'][:100]}")
    print(f"  Unique answers: {q['unique_answer_count']}")
    print(f"  Sample: {q['sample_answers'][:2]}")
