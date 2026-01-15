
import os
import pandas as pd
import numpy as np
from sklearn.cluster import KMeans
from sklearn.preprocessing import StandardScaler
from dotenv import load_dotenv
import psycopg2
import warnings

warnings.filterwarnings('ignore')

# Database Connection
load_dotenv()
db_url = os.getenv("DATABASE_URL")
if not db_url:
    print("Error: DATABASE_URL not set")
    exit(1)

conn = psycopg2.connect(db_url)

query = """
SELECT 
    r.company_id,
    d.dimension_name,
    a.answer_weight
FROM response_items ri
JOIN responses r ON r.response_id = ri.response_id
JOIN questions q ON q.question_id = ri.question_id
JOIN dimensions d ON d.dimension_id = q.dimension_id
JOIN answers a ON a.answer_id = ri.answers[1]
"""

df = pd.read_sql(query, conn)
conn.close()

# Pivot
df_dim_scores = df.groupby(['company_id', 'dimension_name'])['answer_weight'].mean().reset_index()
df_features = df_dim_scores.pivot(index='company_id', columns='dimension_name', values='answer_weight').fillna(0)

# Scale
scaler = StandardScaler()
X_scaled = scaler.fit_transform(df_features)

# KMeans (K=5)
kmeans = KMeans(n_clusters=5, random_state=42, n_init=10)
clusters = kmeans.fit_predict(X_scaled)
df_features['cluster'] = clusters

print(f"\n--- Cluster Counts ---")
print(df_features['cluster'].value_counts().sort_index())

print(f"\n--- Cluster Centroids (Average Scores) ---")
centroids = df_features.groupby('cluster').mean()
print(centroids.round(2).to_string())

# Interpretation helper
print(f"\n--- Interpretation Hints ---")
for i, row in centroids.iterrows():
    print(f"\nCluster {i}:")
    # Get top 2 and bottom 2 dimensions
    sorted_dims = row.sort_values(ascending=False)
    print(f"  High: {sorted_dims.index[0]} ({sorted_dims.iloc[0]:.2f}), {sorted_dims.index[1]} ({sorted_dims.iloc[1]:.2f})")
    print(f"  Low:  {sorted_dims.index[-1]} ({sorted_dims.iloc[-1]:.2f}), {sorted_dims.index[-2]} ({sorted_dims.iloc[-2]:.2f})")
