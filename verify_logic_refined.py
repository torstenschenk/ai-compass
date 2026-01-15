import os
import pandas as pd
import numpy as np
import psycopg2
from scipy.stats import zscore
from dotenv import load_dotenv

# Setup & Data Loading
load_dotenv()
db_url = os.getenv("DATABASE_URL")
conn = psycopg2.connect(db_url)

query = """
SELECT 
    r.company_id,
    d.dimension_name,
    q.question_text,
    q.weight as question_weight,
    a.answer_weight
FROM response_items ri
JOIN responses r ON r.response_id = ri.response_id
JOIN questions q ON q.question_id = ri.question_id
JOIN dimensions d ON d.dimension_id = q.dimension_id
JOIN answers a ON a.answer_id = ri.answers[1]
WHERE d.dimension_name != 'General Psychology'
"""

df_raw = pd.read_sql(query, conn)

# Dimension Level Features
df_features = df_raw.groupby(['company_id', 'dimension_name'])['answer_weight'].mean().reset_index()
df_features = df_features.pivot(index='company_id', columns='dimension_name', values='answer_weight').fillna(0)
df_features = 1 + 4 * (df_features - df_features.min()) / (df_features.max() - df_features.min())

# Gap Calculation
risk_pairs = [
    ('Tech Infrastructure', 'People & Culture'),
    ('Tech Infrastructure', 'Strategy & Business Vision'),
    ('Data Readiness & Literacy', 'Use Cases & Business Value'),
    ('Processes & Scaling', 'Governance & Compliance')
]

for p1, p2 in risk_pairs:
    col_name = f'gap_{p1[:4]}_{p2[:4]}'
    df_features[col_name] = df_features[p1] - df_features[p2]

gap_cols = [c for c in df_features.columns if c.startswith('gap_')]
df_zscores = df_features[gap_cols].apply(zscore)

# Question Level Gaps
df_raw['weighted_gap'] = df_raw['question_weight'] * (5.0 - df_raw['answer_weight'])

def detect_strategic_gaps(company_id):
    findings = []
    
    # 1. Anomalies
    company_z = df_zscores.loc[company_id]
    anomalies = company_z[np.abs(company_z) > 1.5].sort_values(key=abs, ascending=False)
    
    for gap_name, val in anomalies.items():
        if len(findings) >= 2: break
        if "Tech_Peop" in gap_name: d1, d2 = 'Tech Infrastructure', 'People & Culture'
        elif "Tech_Stra" in gap_name: d1, d2 = 'Tech Infrastructure', 'Strategy & Business Vision'
        elif "Data_Use" in gap_name: d1, d2 = 'Data Readiness & Literacy', 'Use Cases & Business Value'
        elif "Proc_Gove" in gap_name: d1, d2 = 'Processes & Scaling', 'Governance & Compliance'
        else: continue
            
        s1, s2 = df_features.loc[company_id, d1], df_features.loc[company_id, d2]
        if s1 > s2:
            findings.append(f"⚠️ Structural Gap: {d1} ({s1:.1f}) > {d2} ({s2:.1f})")
        else:
            findings.append(f"ℹ️ Strategic Lag: {d2} ({s2:.1f}) > {d1} ({s1:.1f})")

    # 2. Weighted Opportunities
    if len(findings) < 2:
        company_items = df_raw[df_raw['company_id'] == company_id].sort_values('weighted_gap', ascending=False)
        for _, row in company_items.iterrows():
            if len(findings) >= 2: break
            desc = f"💡 Strategic Opportunity: {row['question_text'][:50]}... (Weight: {row['question_weight']:.1f})"
            if desc not in findings:
                findings.append(desc)
            
    return findings

# Verify a few companies
print("--- VERIFICATION RESULTS ---")
for cid in df_features.index[:10]:
    results = detect_strategic_gaps(cid)
    print(f"Company {cid}: {len(results)} outcomes")
    for r in results:
        print(f"  - {r}")
    print("-" * 30)

conn.close()
