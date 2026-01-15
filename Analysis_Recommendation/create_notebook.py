
import nbformat as nbf

nb = nbf.v4.new_notebook()

# ------------------------------------------------------------------------------
# 1. Setup & Imports
# ------------------------------------------------------------------------------
text_intro = """# Mittelstand AI Compass: Dynamic Clustering Analysis
### Strategic Rationale
Traditional maturity assessments rely on **linear scoring** (averaging everything). This often hides "structural imbalances"—e.g., a company with great Tech but no Strategy gets the same 'Middle' score as a company with great Strategy but no Tech.

**This notebook aims to:**
1.  **Identify Natural Archetypes**: Use Unsupervised ML (**K-Means**) to find groups that share the same *pattern* of maturity, not just the same level.
2.  **Compare to Rule-Based Logic**: Explicitly visualize where simple averages fail to capture the nuance of SME reality.
3.  **Validate A/B Test Variants**: Prepare the data evidence for a "Dynamic Profile" feature that feels more personalized to the user.
"""

code_imports = """import os
import pandas as pd
import numpy as np
import seaborn as sns
import matplotlib.pyplot as plt
from sklearn.cluster import KMeans
from sklearn.decomposition import PCA
from sklearn.preprocessing import StandardScaler
from dotenv import load_dotenv
import psycopg2

# Visualization settings
sns.set_theme(style="whitegrid")
plt.rcParams['figure.figsize'] = [10, 6]

# Database Connection
load_dotenv()
db_url = os.getenv("DATABASE_URL")
conn = psycopg2.connect(db_url)
print("✓ Connected to Database")
"""

# ------------------------------------------------------------------------------
# 2. Data Loading
# ------------------------------------------------------------------------------
text_data_loading = """## 1. Data Loading
We fetch the raw response items and join them with questions and dimensions. 
**Note:** We exclude the 'General Psychology' dimension as it is optional and does not affect maturity scoring.
"""

code_data_query = """query = \"\"\"
SELECT 
    r.company_id,
    r.response_id,
    d.dimension_name,
    d.dimension_id,
    q.weight as question_weight,
    a.answer_weight
FROM response_items ri
JOIN responses r ON r.response_id = ri.response_id
JOIN questions q ON q.question_id = ri.question_id
JOIN dimensions d ON d.dimension_id = q.dimension_id
JOIN answers a ON a.answer_id = ri.answers[1]
WHERE d.dimension_name != 'General Psychology'
\"\"\"

df = pd.read_sql(query, conn)
df.head()
"""

# ------------------------------------------------------------------------------
# 3. Feature Engineering
# ------------------------------------------------------------------------------
text_feature_eng = """## 2. Feature Engineering
We calculate the **Dimension Scores** for each company.
To ensure comparability across dimensions and with the rule-based profiles, we scale all dimension scores to a **1-5 maturity scale**.

*   **1**: Lowest Maturity
*   **5**: Highest Maturity
"""

code_pivot = """# Group by Company and Dimension to get Dimension Scores
df_dim_scores = df.groupby(['company_id', 'dimension_name'])['answer_weight'].mean().reset_index()

# Pivot to have Dimensions as columns
df_features = df_dim_scores.pivot(index='company_id', columns='dimension_name', values='answer_weight')

# Fill NaNs if any
df_features = df_features.fillna(0)

# Normalize each dimension to a 1-5 scale based on the data range
# (maturity_score = 1 + 4 * normalized_value)
df_features = 1 + 4 * (df_features - df_features.min()) / (df_features.max() - df_features.min())

# Check the shape (Should be 500 rows x 7 core dimensions)
print(f"Feature Matrix Shape: {df_features.shape}")
df_features.head()
"""

# ------------------------------------------------------------------------------
# 4. K-Means Clustering
# ------------------------------------------------------------------------------
text_clustering = """## 3. Unsupervised Clustering (K-Means)
We will now use K-Means to find natural groupings in this multi-dimensional maturity space.
"""

code_elbow = """# Elbow Method to find optimal K
wcss = []
range_k = range(1, 10)

scaler = StandardScaler()
X_scaled = scaler.fit_transform(df_features)

for k in range_k:
    kmeans = KMeans(n_clusters=k, random_state=42, n_init=10)
    kmeans.fit(X_scaled)
    wcss.append(kmeans.inertia_)

plt.figure(figsize=(8, 4))
plt.plot(range_k, wcss, marker='o')
plt.title('Elbow Method')
plt.xlabel('Number of Clusters (k)')
plt.ylabel('Inertia')
plt.show()
"""

text_kmeans_run = """Based on the Elbow plot, we apply K-Means. We will choose **K=5** to identify 5 distinct archetypes.
"""

code_kmeans_apply = """k = 5
kmeans = KMeans(n_clusters=k, random_state=42, n_init=10)
clusters = kmeans.fit_predict(X_scaled)

# Add cluster labels to our dataframe
df_features['cluster'] = clusters
df_features['cluster'] = df_features['cluster'].astype(str) # Categorical

print("Cluster distribution:")
print(df_features['cluster'].value_counts())
"""

# ------------------------------------------------------------------------------
# 5. Visualization & Interpretation
# ------------------------------------------------------------------------------
text_viz = """## 4. Visualizing the Clusters
We use **PCA (Principal Component Analysis)** to reduce the 7D space to 2D for plotting.
"""

code_pca = """# PCA for 2D visualization
pca = PCA(n_components=2)
components = pca.fit_transform(X_scaled)

df_pca = pd.DataFrame(data=components, columns=['PC1', 'PC2'])
df_pca['cluster'] = df_features['cluster'].values
df_pca['company_id'] = df_features.index

plt.figure(figsize=(10, 8))
sns.scatterplot(
    x='PC1', y='PC2', 
    hue='cluster', 
    data=df_pca, 
    palette='viridis', 
    s=100,
    alpha=0.8
)
plt.title('AI Maturity Clusters (PCA Projection)')
plt.show()
"""

text_profiling = """## 5. Interpreting the Clusters (Centroids)
Let's look at the average maturity (1-5) for each dimension within the clusters.
"""

code_centroids = """# Compute mean scores per cluster
cluster_profiles = df_features.groupby('cluster').mean(numeric_only=True)

# Heatmap visualization
plt.figure(figsize=(12, 6))
sns.heatmap(cluster_profiles, annot=True, cmap="YlGnBu", fmt=".2f")
plt.title('Average Maturity (1-5 Scale) by Cluster')
plt.show()
"""

# ------------------------------------------------------------------------------
# 6. Comparison: ML vs. Rule-Based
# ------------------------------------------------------------------------------
text_comparison = """## 6. Comparison: AI Clusters vs. Rule-Based Scoring
We now calculate the traditional **Rule-Based Profile** for each company (based on simple average of the 1-5 scores) and compare it to the **AI Clusters**.
"""

code_rule_based = """# Fetch Rule Definitions
df_rules = pd.read_sql("SELECT * FROM cluster_profiles", conn)
# Ensure float types for comparison
df_rules['score_min'] = df_rules['score_min'].astype(float)
df_rules['score_max'] = df_rules['score_max'].astype(float)

print("Rule-Based Definitions (1-5 Scale):")
print(df_rules[['cluster_name', 'score_min', 'score_max']])

# Calculate Overall Average Score per Company (based on our 1-5 dimension scores)
df_features['avg_score'] = df_features.mean(axis=1, numeric_only=True).astype(float)

# Function to assign Rule-Based Profile
def assign_rule_profile(score):
    for _, row in df_rules.iterrows():
        if row['score_min'] <= score <= row['score_max']:
            return row['cluster_name']
    return "Unknown"

df_features['rule_profile'] = df_features['avg_score'].apply(assign_rule_profile)

print("\\nSample Assignments:")
print(df_features[['avg_score', 'rule_profile', 'cluster']].head(10))
"""

text_crosstab = """### Confusion Matrix: Overlap Analysis
Check where AI and Rules agree or find different patterns.
"""

code_crosstab_viz = """# Crosstab
crosstab = pd.crosstab(df_features['cluster'], df_features['rule_profile'])

plt.figure(figsize=(10, 6))
sns.heatmap(crosstab, annot=True, fmt='d', cmap='Blues')
plt.title('Comparison: AI Clusters vs. Rule-Based Profiles')
plt.xlabel('Rule-Based Profile (Simple Average)')
plt.ylabel('AI Cluster (Multi-Dimensional)')
plt.show()
"""

# ------------------------------------------------------------------------------
# 7. Detailed Conclusion
# ------------------------------------------------------------------------------
text_final_conclusion = """## 7. Detailed Conclusion & Strategic Recommendation

### 1. The Limitation of Rule-Based Scoring
The rule-based approach uses a **linear average**. It masks significant imbalances between dimensions (e.g., high tech vs. low strategy).

### 2. The Value of AI Clustering
Our K-Means analysis identifies archetypes based on **patterns of maturity**, not just the average level. This allows for far more specific and credible advice.

### 3. A/B Testing Recommendation
Test **Variant A (Average Score)** vs. **Variant B (Cluster Matching)**. 
- Variant B should offer a more "personalized" feeling by calling out specific imbalances in the user's maturity profile.
"""

# Append cells
nb.cells.append(nbf.v4.new_markdown_cell(text_intro))
nb.cells.append(nbf.v4.new_code_cell(code_imports))
nb.cells.append(nbf.v4.new_markdown_cell(text_data_loading))
nb.cells.append(nbf.v4.new_code_cell(code_data_query))
nb.cells.append(nbf.v4.new_markdown_cell(text_feature_eng))
nb.cells.append(nbf.v4.new_code_cell(code_pivot))
nb.cells.append(nbf.v4.new_markdown_cell(text_clustering))
nb.cells.append(nbf.v4.new_code_cell(code_elbow))
nb.cells.append(nbf.v4.new_markdown_cell(text_kmeans_run))
nb.cells.append(nbf.v4.new_code_cell(code_kmeans_apply))
nb.cells.append(nbf.v4.new_markdown_cell(text_viz))
nb.cells.append(nbf.v4.new_code_cell(code_pca))
nb.cells.append(nbf.v4.new_markdown_cell(text_profiling))
nb.cells.append(nbf.v4.new_code_cell(code_centroids))
nb.cells.append(nbf.v4.new_markdown_cell(text_comparison))
nb.cells.append(nbf.v4.new_code_cell(code_rule_based))
nb.cells.append(nbf.v4.new_markdown_cell(text_crosstab))
nb.cells.append(nbf.v4.new_code_cell(code_crosstab_viz))
nb.cells.append(nbf.v4.new_markdown_cell(text_final_conclusion))

# Write the notebook
with open('clustering_analysis.ipynb', 'w') as f:
    nbf.write(nb, f)

print("✓ Jupyter Notebook 'clustering_analysis.ipynb' updated: 1-5 scale enabled & General Psychology excluded.")
