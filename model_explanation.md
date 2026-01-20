# AI-Compass: Hybrid Machine Learning Clustering (MLv2)

This notebook explains the logic behind the **Hybrid ML v2** model, how it assigns semantic labels to mathematically derived clusters, and why it is a significant improvement over both manual labeling and traditional rule-based logic.

## 1. How the Model Works

The MLv2 engine uses a **Hybrid Unsupervised-Supervised Approach**:

1.  **Unsupervised Segmentation (K-Means)**: The model takes the normalized dimension scores (7 dimensions) for all companies and groups them into 5 distinct mathematical clusters based on similarity in their data patterns.
2.  **Dimensionality Reduction (PCA)**: We use Principal Component Analysis (PCA) to compress the 7 dimensions into 2 physical coordinates (X and Y) for visualization.
3.  **Semantic Mapping (Dynamic Labeling)**: Instead of manually naming clusters, MLv2 calculates an **Archetype Score** for each cluster (the mean value across all 7 dimensions) and maps it to a professional profile stored in the `cluster_profiles` database table.

## 2. Why Use ML instead of Rules?

The most common question is: *"If the names come from rules, why not just use rule-based clustering (e.g., if average score < 2, then 'Laggard')?"*

Here is why the **Hybrid ML** approach is superior for a benchmarking platform:

### A. Discovery of Natural Centers of Gravity
Rule-based grouping is **Top-Down**. It forces companies into boxes based on arbitrary cut-offs (e.g., 2.5 vs 2.6). 
ML Clustering is **Bottom-Up**. It looks at where your *actual* users are congregating. If most of your users are stuck at level 3, the AI will create more granular sub-divisions within level 3 to help you see the nuance, whereas a rule-based approach would just dump them all into one bucket.

### B. Multi-Dimensional Density
A simple rule usually looks at the **total average score**. 
ML Clustering looks at the **shape** of the 7-dimensional profile. It can identify a cluster of companies that are "Strong in Strategy but Weak in Tech" and treat them as a distinct group, even if their *total average* is the same as a group that is "Weak in Strategy but Strong in Tech."

### C. Dynamic Benchmarking (The Peer Effect)
In a static rule system, if everyone gets better, everyone becomes a "Leader" and the benchmark loses value.
In an ML system, the clusters shift *with the data*. The AI identifies the **top 20%** relative to the rest of the world. As the industry moves forward, the ML clusters move with it, keeping the benchmarking competitive and relevant.

### Important: Zero Bias Design
**Do the cluster names from the DB affect the K-Means outcome?**

**No.** The clustering process is strictly unsupervised. The K-Means algorithm only sees the **raw numerical scores** (the 7 dimensions) to determine how companies should be grouped. 

The names from the database are only fetched and applied **after** the clusters have been mathematically defined. This ensures that the groupings are scientifically objective and not biased by pre-conceived labels.

## 3. The Labeling Logic (All 5 Archetypes)

To ensure that the full spectrum of your strategic archetypes is represented, MLv2 uses **Rank-Based Profile Mapping**:

| Step | Logic | Impact |
| :--- | :--- | :--- |
| **1. Score Calculation** | Mean of all 7 dimension scores for each cluster centroid. | Converts complex data into a single 'Maturity' value. |
| **2. Global Ranking** | The 5 clusters are ranked from 1 (lowest maturity) to 5 (highest maturity). | Distinguishes between relative performance levels in the dataset. |
| **3. Profile Assignment** | The 5 database archetypes are assigned sequentially to the 5 ranked clusters. | **Guarantees all 5 levels (Traditionalist to Leader) are active in the report.** |
