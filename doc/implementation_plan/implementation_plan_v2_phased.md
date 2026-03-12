# Implementation Plan V2: AI-Compass Intelligence Upgrade (Phased & Hybrid)

## Goal
Transform the current static scoring system into an intelligent, data-driven platform using a **Phased Approach** and **Hybrid Architecture**.

## User Review Required
> [!IMPORTANT]
> This plan proposes a Hybrid Architecture:
> *   **Core Logic**: Python Scripts (`.py`) for reusability and production readiness.
> *   **Analysis & Reporting**: Jupyter Notebook (`.ipynb`) for visualization and storytelling.

## Proposed Directory Structure
```text
benchmarking_ai/
├── phase_1_setup/
│   ├── data_loader.py       # SQL -> DataFrame
│   └── feature_gen.py       # Raw Data -> Matrices
├── phase_2_models/
│   ├── benchmark_engine.py  # Percentiles, Peer Groups
│   └── clustering.py        # K-Means, PCA
├── phase_3_validation/
│   └── ab_validator.py      # Rule vs ML comparison
├── Compass_Analysis.ipynb   # INTERACTIVE REPORT & PLAYGROUND
└── implementation_plan_v2_phased.md (This File)
```

## Phases

### Phase 1: Setup & Data Engineering
**Goal**: Create the foundation (Clean Data).
- **Steps**:
    1.  Create `phase_1_setup/` directory.
    2.  Implement `data_loader.py`: Connect to DB (or Load CSVs), fetch `responses`, `companies`.
    3.  Implement `feature_gen.py`: Transform line-item scores into:
        -   `QuestionMatrix` (Companies x Questions)
        -   `DimensionMatrix` (Companies x Dimensions)

### Phase 2: AI/ML Implementation
**Goal**: Build the Intelligence.
- **Steps**:
    1.  Create `phase_2_models/` directory.
    2.  Implement `benchmark_engine.py`: 
        -   `get_peer_group(industry, size)`
        -   `calculate_percentiles(company_id)`
    3.  Implement `clustering.py`:
        -   `train_kmeans(matrix, k)`
        -   `get_pca_components(matrix)`

### Phase 3: A/B Test & Validation
**Goal**: Verify against existing rules.
- **Steps**:
    1.  Create `phase_3_validation/` directory.
    2.  Implement `ab_validator.py`:
        -   Compare New Clusters vs. Old Rule-Based Segments.
        -   Validation: "Does the AI cluster align with our intuition?"

### Phase 4: Reporting & Handover
**Goal**: Final Analysis & User Guide.
- **Steps**:
    1.  Create `Compass_Analysis.ipynb`:
        -   Import modules from Phase 1 & 2.
        -   Run the full pipeline.
        -   Generate Visuals (Scatter plots, Radar charts).
        -   Export findings.
    2.  Document `how_to_reuse.md` (or update README).

## Verification Plan
*   **Phase 1**: Load data in Notebook, assert no NaNs in critical columns.
*   **Phase 2**: Silhouette Score > 0.4 (or acceptable range). Visual check of PCA clusters.
*   **Phase 3**: Cross-tabulation of Cluster vs Industry.
