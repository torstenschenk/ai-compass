import pandas as pd

df = pd.read_csv('DB_Tables_Raw/assessment_processing/company_answers_with_ids_v3.csv')

cols = [col for col in df.columns if col.startswith('q') and col.endswith('_answer_id')]
qids = sorted([int(col.split('_')[0][1:]) for col in cols])
missing = [q for q in range(1, 34) if q not in qids]

print(f'Question columns in v3: {len(cols)}')
print(f'Question IDs: {qids}')
print(f'Missing: {missing if missing else "None - All 33 questions present!"}')
print(f'\nMissing answer count: {df.iloc[:, 1:].isna().sum().sum()}')
print(f'Total cells: {df.shape[0] * (df.shape[1] - 1)}')
