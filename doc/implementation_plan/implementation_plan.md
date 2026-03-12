# Action Plan: AI-Compass Intelligence Upgrade

## Goal
Transform the current static scoring system into an intelligent, data-driven platform capable of **Advanced Benchmarking**, **AI-driven Segmentation**, and **Personalized Recommendations**.

## User Review Required
> [!IMPORTANT]
> This is a multi-phase execution plan. Approval of this document authorizes the creation of the entire `benchmarking_ai` Python package and associated data pipelines.

## Proposed Architecture

All new logic will reside in `benchmarking_ai/`.

### Phase 1: Data Engineering (DataProcessor)
**Goal**: Convert raw SQL tables into ML-ready Feature Matrices.
*   **Feature 1**: `QuestionMatrix` (Rows=Companies, Cols=Questions, Val=Weights).
*   **Feature 2**: `DimensionMatrix` (Rows=Companies, Cols=Dimensions, Val=Aggregated Scores).
*   **Metadata**: Industry, Size, Region attached as filtering tags.

### Phase 2: Benchmarking Engine (Descriptive)
**Goal**: "Where do I stand?"
*   **Dynamic Peer Groups**: Filter dataset by `Industry` and `Size` on the fly.
*   **Percentile Scoring**: Calculate `scipy.stats.percentileofscore` for every company against their peer group.
*   **Gap Analysis**: Identify dimensions where `Company_Score < Peer_Average`.

### Phase 3: AI Clustering & Validator (Unsupervised)
**Goal**: "Who am I really?" & A/B Testing.
*   **Model**: K-Means Clustering on `DimensionMatrix` (k=3 to 5).
    *   *Why*: To find organic "Behavioral Archetypes" (e.g., "Tech-Heavy but Strategy-Poor").
*   **A/B Test Validator**:
    *   Compare `RuleBased_Cluster` vs `ML_Cluster`.
    *   Compute Confusion Matrix and Similarity Score.
    *   **Deliverable**: A report highlighting "Misclassified" companies where the AI sees something the Rules missed.
*   **Visualization**: PCA 2D Scatter Plot showing the landscape of all companies.

### Phase 4: Recommendation Engine (Prescriptive)
**Goal**: "What should I do?"
*   **Logic**: If `Dimension_Score` is in Bottom Quartile -> Recommend specific action items linked to that dimension.

## Implementation Steps

#### 1. [NEW] `benchmarking_ai/data_pipeline.py`
*   `fetch_data()`: SQL -> DataFrame.
*   `create_feature_matrix()`: Pivot/One-hot encoding.

#### 2. [NEW] `benchmarking_ai/models.py`
*   `class BenchmarkEngine`: Handles percentiles and peer masking.
*   `class ClusterEngine`: Handles K-Means, PCA, and prediction.

#### 3. [NEW] `benchmarking_ai/main_analysis.py`
*   The orchestrator script that runs the pipeline, trains models, performs the comparisons, and generates the final report/plots.

## Verification Plan

### Automated Checks
1.  **Data Integrity**: Assert Feature Matrix shape (N_companies, M_features) is correct.
2.  **Model Quality**: Calculate Silhouette Score for K-Means (Target > 0.4).
3.  **A/B Comparison**: Print percentage overlap between Rule-Based and ML assignments.

### Deliverables
*   **Report**: `AI_Upgrade_Results.md` (Auto-generated findings).
*   **Plots**: `cluster_pca.png`, `benchmark_radar.png`.
