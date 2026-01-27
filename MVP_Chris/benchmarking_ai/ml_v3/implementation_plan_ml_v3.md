# Implementation Plan: Benchmarking AI (v3) - Comprehensive Intelligence

This plan outlines the evolution from `ml_v2` (Hybrid Clustering) to `ml_v3`, which integrates **Anomaly Detection** and **Personalized Recommendations**.


## Goal
To transform the system from a "Passive Categorization" tool (Clustering) into an **"Active Intelligence"** engine.
**Crucially, this system is designed for Real-Time Inference**: It will accept a single company's assessment data (e.g., from a frontend) and instantaneously return their Cluster, Anomalies, and Next Best Actions.

## Proposed Architecture (`benchmarking_ai/ml_v3/`)

### 1. Training Pipeline (Offline / Periodic)
- **`train_models.py`**:
    - Fetches historical data from DB.
    - Trains `ClusterEngine` (K-Means), `AnomalyDetector` (Z-Score Thresholds), and `Recommender` (k-NN).
    - **Saves** the trained models and scalers to disk (`.pkl` files).

### 2. Inference Engine (Real-Time)
- **`inference.py`**:
    - Loads the pre-trained models.
    - Accepts a single "Company Profile" (Dictionary/JSON of scores).
    - **Predicts** Cluster Assignment.
    - **Detects** Anomalies for that specific input.
    - **Recommends** Next Best Action based on nearest neighbors in the training set.

### [Data Engineering]
#### `data_pipeline.py`
- Inherit from v2.
- Add methods to **Serialize/Deserialize** models.

### [Modeling]
#### `models.py`
Refactored for separation of `fit()` and `predict()`.

**Class `ClusterEngine`**
- `fit(all_data)`: Learn centroids.
- `predict(single_company_data)`: Return "The Experimental Explorer".

**Class `AnomalyDetector`**
- `fit(all_data)`: Learn population distributions (Mean/Std Dev for gaps).
- `detect(single_company_data)`: Compare input against population stats.

**Class `Recommender`**
- `fit(all_data)`: Store the neighbor tree (k-NN).
- `recommend(single_company_data)`: Find neighbors for input -> Suggest Action.

## Implementation Steps

1.  **Model Refactoring**: Update `models.py` to ensure all classes have clear `save/load` and `fit/predict` patterns.
2.  **Training Script**: Create `train_models.py` to generate the artifacts (`kmeans.pkl`, `knn.pkl`, `stats.json`).
3.  **Inference Script**: Create `inference.py` that loads these artifacts and simulates a frontend request with synthetic data.
4.  **Verification**:
    -   **Synthetic Tests**: Use manually crafted profiles (e.g., "High Tech, Low Strategy") to verify Anomaly logic sensitivity.
    -   **Integration Test**: Fetch a real company (e.g., **ID 3**) from the database and pass it through the inference engine to verify end-to-end connectivity.

5.  **API Integration Layer (Next Step)**:
    -   Create `api.py` (Flask/FastAPI) to wrap `inference.py`.
    -   Define a POST endpoint `/analyze` that accepts user scores and returns the JSON payload (Cluster, Anomalies, Recommendations).
    -   This layer handles the HTTP request/response cycle, making the system accessible to the Frontend.

