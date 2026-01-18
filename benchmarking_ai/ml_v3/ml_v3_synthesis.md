# ML v3: Logic Synthesis & Evolution

This document outlines how `ml_v3` evolves our previous analytical work into a production-ready "Real-Time Intelligence Engine".

## Core synthesis
`ml_v3` creates a unified system by integrating three distinct foundations:
1.  **Analysis Logic** (from `Analysis_Recommendation` notebooks)
2.  **Structural Understanding** (from `ml_v2` Hybrid Clustering)
3.  **Production Engineering** (New `ml_v3` "Train-Once, Predict-Anywhere" Architecture)

| Component | Logic Source | Evolution in `ml_v3` System |
| :--- | :--- | :--- |
| **Anomaly Detection** | `anomaly_detection.ipynb`<br>*(Z-Scores on Risk Pairs)* | Refactored into the **`AnomalyDetector` Class**. <br>• **Upgrade**: Added persistence. The model calculates population statistics (mean/std) once during training and saves them (`anomaly_stats.json`). This allows for instant detection on single input profiles without loading the full database. |
| **Recommendations** | `recommendation_analysis.ipynb`<br>*(k-Nearest Neighbors)* | Refactored into the **`Recommender` Class**. <br>• **Upgrade 1 ("The Stretch")**: Instead of just finding *any* neighbor, the model now specifically filters for "Next Level" peers who are **15-30% more mature** than the user.<br>• **Upgrade 2 ("Safety Net")**: Implemented a fallback logic ("Weakest Link") to ensure that even top performers or unique profiles receive actionable advice. |
| **Clustering** | `ml_v2`<br>*(Hybrid K-Means)* | Integrated as the **Foundation Context**. <br>• The system first classifies the user (e.g., "The Traditionalist"), providing the necessary semantic context. The Anomaly and Recommendation engines then operate *within* this understanding to provide relevant insights. |

## The "Active Intelligence" Shift
While the notebooks were designed for **Batch Analysis** (analyzing static datasets), `ml_v3` is designed for **Real-Time Inference**.

*   **Training (`train_models.py`)**: The logic from the notebooks is now used to *learn* patterns from history.
*   **Inference (`inference.py`)**: These learned patterns are applied instantly to new, incoming data from the frontend.
