
import nbformat as nbf

nb = nbf.v4.new_notebook()

# ------------------------------------------------------------------------------
# 1. Setup & Imports
# ------------------------------------------------------------------------------
text_intro = """# AI-Compass: A/B Testing Validation Framework
### Strategic Rationale
To prove the value of AI/ML, we shouldn't just replace the existing logic. High-stakes consulting tools require **A/B Testing** to measure user engagement, trust, and conversion.

**This notebook simulates the two "Insight Modes":**
1.  **Group A: Deterministic (Rules)**: The current "Safe" approach using linear averages and hard-coded mappings.
2.  **Group B: Probabilistic (AI/ML)**: The "Intelligent" approach using clustering, percentiles, and peer-benchmarking.
"""

code_imports = """import os
import pandas as pd
import numpy as np
import seaborn as sns
import matplotlib.pyplot as plt
from sklearn.cluster import KMeans
from sklearn.neighbors import NearestNeighbors
from scipy.stats import percentileofscore
from dotenv import load_dotenv
import psycopg2

# Visualization
sns.set_theme(style="white")
plt.rcParams['figure.figsize'] = [10, 6]

# DB Connection
load_dotenv()
db_url = os.getenv("DATABASE_URL")
conn = psycopg2.connect(db_url)
"""

# ------------------------------------------------------------------------------
# 2. Shared Data Engine
# ------------------------------------------------------------------------------
text_data_loading = """## 1. The Data Engine
The engine fetches the 1-5 maturity scores (excluding Psychology) that both groups will use as input.
"""

code_data_prep = """query = \"\"\"
SELECT 
    r.company_id,
    c.industry,
    d.dimension_name,
    a.answer_weight
FROM response_items ri
JOIN responses r ON r.response_id = ri.response_id
JOIN companies c ON c.company_id = r.company_id
JOIN questions q ON q.question_id = ri.question_id
JOIN dimensions d ON d.dimension_id = q.dimension_id
JOIN answers a ON a.answer_id = ri.answers[1]
WHERE d.dimension_name != 'General Psychology'
\"\"\"

df = pd.read_sql(query, conn)

# Prepare Features
df_features = df.groupby(['company_id', 'industry', 'dimension_name'])['answer_weight'].mean().reset_index()
df_features = df_features.pivot(index=['company_id', 'industry'], columns='dimension_name', values='answer_weight').fillna(0)
# Scale to 1-5
df_features = 1 + 4 * (df_features - df_features.min()) / (df_features.max() - df_features.min())

# Calculate total score for rule-based
df_features['total_score'] = df_features.mean(axis=1)

# Preparation for ML (Clustering)
X = df_features.drop(columns=['total_score'])
kmeans = KMeans(n_clusters=5, random_state=42, n_init=10).fit(X)
centroids = kmeans.cluster_centers_

print(f"Data engine ready. Processing {len(df_features)} companies.")
"""

# ------------------------------------------------------------------------------
# 3. Group A: Deterministic Logic
# ------------------------------------------------------------------------------
text_group_a = """## 2. Group A Logic (Deterministic Rules)
This group sees the world through static rules and global averages.
"""

code_group_a = """# Fetch Rule Definitions
df_rules = pd.read_sql("SELECT * FROM cluster_profiles", conn)
df_rules['score_min'] = df_rules['score_min'].astype(float)
df_rules['score_max'] = df_rules['score_max'].astype(float)

global_avg = df_features['total_score'].mean()

def get_group_a_insights(company_id):
    row = df_features.loc[company_id]
    score = row['total_score']
    
    # 1. Profile Assignment (Deterministic)
    profile = "Unknown"
    for _, r in df_rules.iterrows():
        if r['score_min'] <= score <= r['score_max']:
            profile = f"{r['cluster_name']} (Score {score:.1f})"
            break
            
    # 2. Benchmarking (Simple Average)
    benchmarking = f"You are {'above' if score >= global_avg else 'below'} average ({score:.1f} vs {global_avg:.1f})"
    
    # 3. Recommendation (Static Mapping)
    # Finding the lowest dimension
    lowest_dim = row.drop('total_score').idxmin()
    recommendation = f"Static Rule: Your {lowest_dim} is lowest. Focus on improving this area first."
    
    return {
        'Profile': profile,
        'Benchmarking': benchmarking,
        'Recommendation': recommendation
    }
"""

# ------------------------------------------------------------------------------
# 4. Group B: Probabilistic Logic
# ------------------------------------------------------------------------------
text_group_b = """## 3. Group B Logic (Probabilistic AI/ML)
This group sees similarities, percentiles, and peer-driven success paths.
"""

code_group_b = """def get_group_b_insights(company_id):
    row = df_features.loc[company_id]
    data = row.drop('total_score').values.reshape(1, -1)
    score = row['total_score']
    industry = company_id[1]
    
    # 1. Profile Assignment (Cluster Match %)
    distances = np.linalg.norm(centroids - data, axis=1)
    # Convert distances to probabilities (Match %)
    probs = 1 / (distances + 1e-5)
    probs = probs / probs.sum()
    best_cluster = np.argmax(probs)
    match_pct = probs[best_cluster] * 100
    profile = f"Nearest to Cluster {best_cluster} ({match_pct:.0f}% structural match)"
    
    # 2. Benchmarking (Percentile in Industry/Peer Group)
    industry_scores = df_features.xs(industry, level='industry')['total_score']
    percentile = percentileofscore(industry_scores, score)
    benchmarking = f"You are in the top {100-percentile:.0f}% of your '{industry}' peer group."
    
    # 3. Recommendation (Lookalike Pathway)
    # Simplified Peer-based: Recommend the dimension where the top 10% of industry excel most vs user
    top_peers = industry_scores[industry_scores > score].sort_values(ascending=False).head(10)
    if not top_peers.empty:
        peer_idx = top_peers.index
        peer_data = df_features.loc[(slice(None), industry), :].loc[peer_idx].drop(columns=['total_score']).mean()
        gap = peer_data - row.drop('total_score')
        recommendation = f"Peer Insight: Companies similar to you that reached the next level focused on '{gap.idxmax()}'."
    else:
        recommendation = "Peer Insight: You are leading your industry. Explore niche AI innovations."
        
    return {
        'Profile': profile,
        'Benchmarking': benchmarking,
        'Recommendation': recommendation
    }
"""

# ------------------------------------------------------------------------------
# 5. Side-by-Side Dashboard Simulation
# ------------------------------------------------------------------------------
text_dashboard = """## 4. The Result: A/B Testing Dashboard
Here is what the **same user** would see in Group A vs. Group B. Note the difference in tone and precision.
"""

code_dashboard = """def render_ab_comparison(company_id):
    a = get_group_a_insights(company_id)
    b = get_group_b_insights(company_id)
    
    print(f"REPORT FOR COMPANY ID: {company_id[0]} (Industry: {company_id[1]})")
    print("="*80)
    print(f"{'FEATURE':<20} | {'GROUP A (DETERMINISTIC)':<30} | {'GROUP B (PROBABILISTIC)':<30}")
    print("-"*80)
    print(f"{'Profile':<20} | {a['Profile']:<30} | {b['Profile']:<30}")
    print(f"{'Benchmarking':<20} | {a['Benchmarking']:<30} | {b['Benchmarking']:<30}")
    print(f"{'Recommendation':<20} | {a['Recommendation']:<30} | {b['Recommendation']:<30}")
    print("="*80)

# Pick a sample company
sample_cid = df_features.index[10]
render_ab_comparison(sample_cid)
"""

text_conclusion = """## 5. Summary & Next Steps
**Key Observations:**
- **Group A** is easy to explain but feels like a "form letter".
- **Group B** provides high-precision insights that feel personalized and data-backed.

**Validation Strategy:**
1.  **Metric**: "Click-through rate" on the Recommendation.
2.  **Metric**: User Rating (1-5 stars) on "How accurate does this feel?".
3.  **A/B Test Execution**: Randomly hash the `user_id` to assign A or B in the backend and track these metrics in your database.
"""

# Assemble
cells = [
    nbf.v4.new_markdown_cell(text_intro),
    nbf.v4.new_code_cell(code_imports),
    nbf.v4.new_markdown_cell(text_data_loading),
    nbf.v4.new_code_cell(code_data_prep),
    nbf.v4.new_markdown_cell(text_group_a),
    nbf.v4.new_code_cell(code_group_a),
    nbf.v4.new_markdown_cell(text_group_b),
    nbf.v4.new_code_cell(code_group_b),
    nbf.v4.new_markdown_cell(text_dashboard),
    nbf.v4.new_code_cell(code_dashboard),
    nbf.v4.new_markdown_cell(text_conclusion)
]
nb.cells.extend(cells)

with open('ab_testing_simulation.ipynb', 'w') as f:
    nbf.write(nb, f)

print("✓ Jupyter Notebook 'ab_testing_simulation.ipynb' created successfully.")
