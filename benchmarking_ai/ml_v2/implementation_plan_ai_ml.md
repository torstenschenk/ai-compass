# Implementation Plan: AI-Compass Intelligence Upgrade

## Goal
Transform the current static scoring system into an intelligent, data-driven platform. We will use a **Phased Approach** to ensure modularity and maintainability, separating concerns into distinct folders within `benchmarking_ai/`.

## Proposed Architecture (Hybrid Approach)
We will use **Python Scripts** for core reusable logic (Classes, Data Pipelines) and a **Jupyter Notebook** for high-level orchestration, visual analysis, and the final report.

### Directory Structure
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
├── phase_4_report/
│   └── model_saver.py       # Persistence utils
└── Compass_Analysis.ipynb   # INTERACTIVE REPORT & PLAYGROUND
```

## Phases

### Phase 1: Setup & Data Engineering
**Goal**: Create the foundation.
- **Inputs**: Raw SQL Tables (`responses`, `companies`, etc.).
- **Outputs**: Cleaned `QuestionMatrix` and `DimensionMatrix` (DataFrames).
- **Files**:
    - `phase_1_setup/data_loader.py`: Handles database connection and querying.
    - `phase_1_setup/feature_gen.py`: Transforms lists of scores into pivot tables.

### Phase 2: AI/ML Implementation
**Goal**: Build the Brain.
- **Logic**:
    - **Smart Benchmarking**: Dynamic peer group selection + Percentile calculation.
    - **Clustering**: K-Means to find natural groupings (k=3-5) and PCA for visualization.
- **Files**:
    - `phase_2_models/benchmark_engine.py`: `BenchmarkEngine` class.
    - `phase_2_models/clustering.py`: `ClusterEngine` class.

### Phase 3: A/B Test & Validation
**Goal**: Trust but Verify.
- **Logic**: Compare `RuleBased_Segment` (existing) vs `ML_Cluster` (new).
- **Metric**: Confusion Matrix / Overlap %.
- **Files**:
    - `phase_3_validation/ab_validator.py`: Comparison logic.

### Phase 4: Deployment & Inference
**Goal**: Enable Real-Time Scoring for the Product.
- **Logic**:
    - **Persistence**: Save trained `KMeans`, `Scaler`, and `PCA` models to disk (`.joblib`).
    - **Inference**: Creating a lightweight script that takes new user inputs, preprocesses them, and returns their Cluster + Peer Standing instantly.
- **Files**:
    - `ml_v1/models.py`: Add `save_models()` and `load_models()`.
    - `ml_v1/inference.py`: Demo script simulating a web backend request.

### Phase 5: Frontend Integration (React)
**Goal**: Connect the ML Brain to the User Interface.
- **Architecture**:
    - **Backend API (FastAPI/Flask)**: Wraps `inference.py` into a REST API endpoint (e.g., `POST /predict`).
    - **Frontend (React)**: Collects user assessment answers and displays the resulting Cluster + Visualizations.
- **Data Flow**:
    1.  User submits assessment on React App.
    2.  React sends JSON payload to Python API.
    3.  Python API loads `KMeans` model, predicts cluster, calculates percentile.
    4.  JSON response sent back to React (e.g., `{ "cluster": "Tech Specialist", "percentile": 85 }`).
    5.  React renders "You are a Tech Specialist" dashboard.

## Verification Plan
1.  **Phase 1 Check**: Load data in Notebook, check `df.head()` and shapes.
2.  **Phase 2 Check**: Run Clustering. Check Silhouette Score. Plot 2D PCA.
3.  **Phase 3 Check**: Output "Agreement Score" (e.g., "85% match with rule-based").
