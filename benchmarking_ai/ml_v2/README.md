# AI-Compass Benchmarking AI (v1)

This project implements an AI-driven benchmarking system for analyzing company maturity across multiple dimensions.
It utilizes **K-Means Clustering** and **PCA** to identify market segments (clusters) and provides interactive analysis via Jupyter Notebooks.

## Directory Structure
- `ml_v1/`: Contains the core logic for Version 1.
    - `data_pipeline.py`: Handles database connection and matrix creation.
    - `models.py`: Contains `ClusterEngine` (K-Means + PCA).
    - `main_analysis.py`: Orchestrator script for generating reports `cluster_report.txt` and plots `cluster_pca.png`.
    - `Compass_Analysis.ipynb`: **Primary Interactive Deliverable**. Run this for visual analysis.
    - `ab_testing/`: Contains A/B comparison logic (`ab_validator.py`) against legacy rules.

## Setup & Requirements

### 1. Environment
Ensure you are using the correct Python environment (Virtual Environment).
**Path**: `d:\SpicedProjects\Projects\ai-compass\.venv`

### 2. Dependencies
Install required packages if missing:
```bash
pip install pandas seaborn matplotlib scikit-learn psycopg2-binary python-dotenv jinja2
```

## Running the Analysis

1.  **Open VS Code**.
2.  Open `benchmarking_ai/ml_v1/Compass_Analysis.ipynb`.
3.  **Select Kernel**: Ensure the top-right Kernel is set to your `.venv` (Python 3.x).
4.  **Run All Cells**:
    - Loads data from DB.
    - Trains K-Means (5 Clusters).
    - Maps Clusters to Logical Names (1 - Laggards to 5 - Leaders).
    - Displays Heatmaps and PCA Scatter Plots.

## Key Insights
- **5 Segments Identified**: Laggards, Data-Rich/Tech-Poor, Middle Pack, Tech Specialists, Leaders.
- **PCA Analysis**:
    - **PCA 1**: Strategic Maturity (Business Vision, Governance).
    - **PCA 2**: Technical Readiness (Data, Infrastructure).
