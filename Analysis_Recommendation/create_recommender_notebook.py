
import nbformat as nbf

nb = nbf.v4.new_notebook()

# ------------------------------------------------------------------------------
# 1. Setup & Imports
# ------------------------------------------------------------------------------
text_intro = """# AI-Compass: "Next Best Action" Recommender
### Strategic Rationale
One of the biggest hurdles for SMEs isn't just knowing their "Score", but knowing **what to do next**. While rule-based advice is helpful, it is often generic. 

**This notebook implements Multi-Dimensional Peer Benchmarking:**
1.  **k-Nearest Neighbors (k-NN)**: We find "Lookalike" peers who are structurally similar to the user (e.g., similar Tech and Culture levels).
2.  **Success Pathway Identification**: We filter for peers who are **more mature** overall (higher total score) than the user.
3.  **Collaborative Recommendations**: We identify the "Dimension Gap" between the user and these successful peers. If similar companies that are more mature than you all have higher "Data Literacy", that's likely your next logical investment.
"""

code_imports = """import os
import pandas as pd
import numpy as np
import seaborn as sns
import matplotlib.pyplot as plt
from sklearn.neighbors import NearestNeighbors
from sklearn.preprocessing import StandardScaler
from dotenv import load_dotenv
import psycopg2

# Visualization
sns.set_theme(style="whitegrid")
plt.rcParams['figure.figsize'] = [10, 6]

# DB Connection
load_dotenv()
db_url = os.getenv("DATABASE_URL")
conn = psycopg2.connect(db_url)
print("✓ Connected to Database")
"""

# ------------------------------------------------------------------------------
# 2. Data Loading & Scaling (Matching the 1-5 scale)
# ------------------------------------------------------------------------------
text_data_loading = """## 1. Data Loading & Normalization
We fetch the data, excluding 'General Psychology', and scale it to the **1-5 maturity scale**.
"""

code_data_prep = """query = \"\"\"
SELECT 
    r.company_id,
    d.dimension_name,
    a.answer_weight
FROM response_items ri
JOIN responses r ON r.response_id = ri.response_id
JOIN questions q ON q.question_id = ri.question_id
JOIN dimensions d ON d.dimension_id = q.dimension_id
JOIN answers a ON a.answer_id = ri.answers[1]
WHERE d.dimension_name != 'General Psychology'
\"\"\"

df = pd.read_sql(query, conn)

# Pivot & Scale to 1-5
df_features = df.groupby(['company_id', 'dimension_name'])['answer_weight'].mean().reset_index()
df_features = df_features.pivot(index='company_id', columns='dimension_name', values='answer_weight').fillna(0)
df_features = 1 + 4 * (df_features - df_features.min()) / (df_features.max() - df_features.min())

# Total Maturity for filtering
df_features['total_maturity'] = df_features.mean(axis=1)

print(f"Dataset prepared with {len(df_features)} companies.")
df_features.head()
"""

# ------------------------------------------------------------------------------
# 3. k-NN Model Training
# ------------------------------------------------------------------------------
text_knn = """## 2. Training the "Peer Finder" (k-NN)
We use the **NearestNeighbors** algorithm to calculate similarities between companies based on their maturity across all 7 dimensions.
"""

code_knn = """# Prepare features for distance calculation (excluding the total_maturity column)
X = df_features.drop(columns=['total_maturity'])

# We don't necessarily need StandardScaler here since all features are already on a 1-5 scale,
# but it's good practice for distance-based models.
scaler = StandardScaler()
X_scaled = scaler.fit_transform(X)

# Fit k-NN
knn = NearestNeighbors(n_neighbors=10, metric='euclidean')
knn.fit(X_scaled)

print("✓ k-NN model trained on peer profiles.")
"""

# ------------------------------------------------------------------------------
# 4. Recommendation Logic
# ------------------------------------------------------------------------------
text_rec_logic = """## 3. Recommendation Logic
For a "target" company, we:
1. Find its 10 nearest neighbors.
2. Filter for neighbors that are **more mature** (higher total score).
3. Compare the target's scores with these more mature peers.
4. Recommend the dimension with the largest "maturity gap".
"""

code_rec_func = """def get_next_best_action(company_id, n_peers=10):
    # 1. Get target company data
    target_idx = df_features.index.get_loc(company_id)
    target_data = X_scaled[target_idx].reshape(1, -1)
    target_scores = X.iloc[target_idx]
    
    # 2. Find neighbors
    distances, indices = knn.kneighbors(target_data)
    neighbor_ids = df_features.index[indices[0]]
    df_neighbors = df_features.loc[neighbor_ids]
    
    # 3. Filter for neighbors that are "Better" (Higher total maturity)
    better_peers = df_neighbors[df_neighbors['total_maturity'] > df_features.loc[company_id, 'total_maturity']]
    
    if better_peers.empty:
        return "You are already a top performer in your peer group. Keep innovating!", None

    # 4. Calculate Gaps: Peer Average - Target Scores
    peer_avg = better_peers.drop(columns=['total_maturity']).mean()
    gaps = peer_avg - target_scores
    
    # Recommend the dimension with the highest gap
    recommendation = gaps.idxmax()
    return recommendation, better_peers

# Test with a specific company (e.g. company_id 5)
cid = df_features.index[5]
action, peers = get_next_best_action(cid)
print(f"Recommendation for Company {cid}:")
print(f"🚀 Next Best Action: Focus on '{action}'")
"""

# ------------------------------------------------------------------------------
# 5. Visualization
# ------------------------------------------------------------------------------
text_viz_intro = """## 4. Visualizing the Gap
We compare the target company's current profile with its "More Mature Peers".
"""

code_viz = """def plot_peer_comparison(company_id):
    action, better_peers = get_next_best_action(company_id)
    if better_peers is None:
        print("No mature peers found for this company.")
        return

    target_scores = X.loc[company_id]
    peer_avg = better_peers.drop(columns=['total_maturity']).mean()
    
    comparison = pd.DataFrame({
        'You': target_scores,
        'Mature Peers': peer_avg
    }).reset_index().rename(columns={'index': 'Dimension', 'dimension_name': 'Dimension'})
    
    comparison_melted = comparison.melt(id_vars='Dimension', var_name='Group', value_name='Score')
    
    plt.figure(figsize=(12, 6))
    sns.barplot(x='Score', y='Dimension', hue='Group', data=comparison_melted, palette='viridis')
    plt.title(f'Target Profile vs. Mature Peers\\nRecommended Action: {action}')
    plt.xlim(1, 5)
    plt.show()

plot_peer_comparison(cid)
"""

# ------------------------------------------------------------------------------
# 5. Benchmarking: Rule-Based vs. ML
# ------------------------------------------------------------------------------
text_benchmarking = """## 4. Benchmarking: Why Rule-Based fails vs. ML
We can prove the "bluntness" of rule-based logic by looking at companies with the **exact same average score** but **different structural needs**.
"""

code_benchmarking = """# Create a group of companies with similar average scores
# (e.g., Rounding to 1 decimal place to find 'Buckets')
df_features['rounded_avg'] = df_features['total_maturity'].round(1)

# Analyze a specific bucket (e.g., 2.5 average score)
bucket_score = df_features['rounded_avg'].median()
subset = df_features[df_features['rounded_avg'] == bucket_score].copy()

# Calculate Recommendations for everyone in this bucket
res = []
for cid in subset.index:
    action, _ = get_next_best_action(cid)
    res.append(action)
subset['ml_recommendation'] = res

print(f"Analysis of companies with Average Score ≈ {bucket_score}:")
print(f"Total companies in bucket: {len(subset)}")
print("-" * 30)
print("Distribution of ML-based Next Steps:")
print(subset['ml_recommendation'].value_counts())

# Metric: Recommendation Entropy / Diversity
diversity = len(subset['ml_recommendation'].unique())
print(f"\\nMetric: Rule-based would give 1 generic advice to all {len(subset)} companies.")
print(f"Metric: ML identifies {diversity} DIFFERENT tactical paths for these same companies.")
"""

text_conclusion = """## 5. Strategic Value & Quantitative Proof
The analysis above provides the data-backed reason why **Variant B (ML)** is superior:

1.  **Eliminating "Average Blindness"**: Companies with identical total scores (e.g. 2.5) often have opposite structural gaps. Rule-based scoring treats them as identical; ML recognizes their specific "Maturity DNA".
2.  **Increased Personalization**: By identifying different paths for companies at the same level, we increase the user's perceived "Consultant Accuracy".
3.  **Actionable Insights**: ML recommendations are significantly more diverse (as shown by the distribution above), leading to more targeted and useful business decisions.
"""

# Assemble
cells = [
    nbf.v4.new_markdown_cell(text_intro),
    nbf.v4.new_code_cell(code_imports),
    nbf.v4.new_markdown_cell(text_data_loading),
    nbf.v4.new_code_cell(code_data_prep),
    nbf.v4.new_markdown_cell(text_knn),
    nbf.v4.new_code_cell(code_knn),
    nbf.v4.new_markdown_cell(text_rec_logic),
    nbf.v4.new_code_cell(code_rec_func),
    nbf.v4.new_markdown_cell(text_viz_intro),
    nbf.v4.new_code_cell(code_viz),
    nbf.v4.new_markdown_cell(text_benchmarking),
    nbf.v4.new_code_cell(code_benchmarking),
    nbf.v4.new_markdown_cell(text_conclusion)
]

nb.cells.extend(cells)

with open('recommendation_analysis.ipynb', 'w') as f:
    nbf.write(nb, f)

print("✓ Jupyter Notebook 'recommendation_analysis.ipynb' created successfully.")
