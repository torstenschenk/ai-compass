# AI Compass ML Model Architecture & Data Flow

## Overview
The AI Compass system uses a multi-component ML pipeline for AI maturity assessment, clustering, gap analysis, and roadmap generation.

---

## Folder Structure

### Primary ML Folders

#### 1. **`benchmarking_ai/ml_v5/`** (Active Production Models)
**Location**: `D:\SpicedProjects\Projects\ai-compass\benchmarking_ai\ml_v5`

**Purpose**: Current production ML system (Version 5)

**Key Files**:
- `models.py` - Core ML classes:
  - `ClusterEngine` - KMeans clustering for maturity segmentation
  - `StrategicGapAnalyzer` - Gap detection and prioritization
  - `RoadmapGenerator` - KNN-based roadmap generation
- `inference.py` - Main inference orchestrator
- `utils.py` - Helper functions for narrative generation
- `model_artifacts/v5/` - Trained model files:
  - `cluster_kmeans.pkl` - KMeans model (5 clusters)
  - `cluster_scaler.pkl` - StandardScaler for clustering
  - `roadmap_knn.pkl` - KNN model (15 neighbors)
  - `roadmap_scaler.pkl` - StandardScaler for roadmap
  - `industry_data.pkl` - Industry benchmark data
  - `dim_data.pkl` - Dimension training data

#### 2. **`models/`** (Legacy/Alternative Models)
**Location**: `D:\SpicedProjects\Projects\ai-compass\models`

**Status**: Legacy or experimental models (not currently used in production)

**Note**: The application uses `ml_v5` exclusively. This folder may contain older versions or experimental work.

---

## Complete Data Flow: Training → Frontend

### Phase 1: Model Training (Offline)

**Location**: `benchmarking_ai/ml_v5/`

**Training Scripts** (likely separate, not in current codebase):
1. **Data Collection**: Historical company assessments aggregated
2. **Feature Engineering**: 7 dimensions calculated from questionnaire responses
3. **Model Training**:
   - **Clustering**: KMeans trained on dimension scores → 5 maturity clusters
   - **Roadmap KNN**: KNN trained on dimension vectors → peer matching
4. **Serialization**: Models saved as `.pkl` files in `model_artifacts/v5/`

**Trained Artifacts**:
```
benchmarking_ai/ml_v5/model_artifacts/v5/
├── cluster_kmeans.pkl      # 5-cluster KMeans model
├── cluster_scaler.pkl      # Feature scaler for clustering
├── roadmap_knn.pkl         # 15-neighbor KNN for peer matching
├── roadmap_scaler.pkl      # Feature scaler for roadmap
├── industry_data.pkl       # Industry benchmark statistics
└── dim_data.pkl            # Training dimension data
```

---

### Phase 2: Backend Integration

#### 2.1 Model Loading
**File**: `benchmarking_ai/ml_v5/inference.py`

```python
class InferenceEngine:
    def __init__(self):
        self.ce = ClusterEngine()      # Loads cluster models
        self.sga = StrategicGapAnalyzer()
        self.rg = RoadmapGenerator()   # Loads KNN models
        
        # Models loaded from model_artifacts/v5/
        self.ce.load_model(path)
        self.sga.load_model(path)
        self.rg.load_model(path)
```

#### 2.2 API Endpoint
**File**: `Application_Prototype/mvp_v1/backend/routers/results.py`

```python
@router.get("/api/v1/responses/{response_id}/results")
async def get_results(response_id: int):
    # 1. Fetch questionnaire responses from database
    # 2. Calculate dimension scores
    # 3. Run ML inference
    analysis = engine.run_analysis(
        company_dim_series,
        company_question_df,
        company_industry
    )
    # 4. Return results to frontend
```

#### 2.3 ML Inference Pipeline
**File**: `benchmarking_ai/ml_v5/inference.py::run_analysis()`

**Steps**:
1. **Cluster Prediction** (`ClusterEngine`):
   - Input: 7 dimension scores
   - Process: StandardScaler → KMeans.predict()
   - Output: Cluster ID (1-5), Cluster Name, Coordinates

2. **Percentile Calculation** (`ClusterEngine`):
   - Input: Total maturity score, industry
   - Process: Compare against `industry_data.pkl`
   - Output: Percentile rank (e.g., "Top 25%")

3. **Peer Benchmark** (`RoadmapGenerator`):
   - Input: Dimension scores
   - Process: StandardScaler → KNN.kneighbors() → Average 15 nearest peers
   - Output: Peer dimension scores (for Radar Chart)

4. **Strategic Gap Analysis** (`StrategicGapAnalyzer`):
   - Input: Dimension scores, questionnaire responses
   - Process: 
     - Detect structural imbalances (dimension variance)
     - Identify critical gaps (low scores + high impact)
     - Calculate impact scores
   - Output: Top 2 strategic findings

5. **Executive Briefing** (`StrategicGapAnalyzer`):
   - Input: Strategic findings, dimension scores
   - Process: Template-based narrative synthesis
   - Output: Markdown-formatted executive summary

6. **Roadmap Generation** (`RoadmapGenerator`):
   - Input: Dimension scores, strategic gaps, questionnaire responses
   - Process:
     - Phase 1: Address strategic gaps (0-3 months)
     - Phase 2: Build on strengths (3-9 months)
     - Phase 3: Advanced capabilities (9+ months)
     - KNN-based peer comparison for "Growth Opportunities"
   - Output: 3-phase roadmap with recommendations

---

### Phase 3: Frontend Display

#### 3.1 API Response Structure
**Endpoint**: `GET /api/v1/responses/{response_id}/results`

**Response Schema** (`backend/schemas/results.py`):
```json
{
  "company_id": 123,
  "response_id": 456,
  "total_score": 3.2,
  "cluster": {
    "cluster_id": 3,
    "cluster_name": "3 - Builder",
    "coordinates": [0.5, 0.3, ...]
  },
  "dimension_scores": {
    "Strategy & Business Vision": 3.5,
    "Data Readiness & Literacy": 2.8,
    ...
  },
  "benchmark_scores": {
    "Strategy & Business Vision": 3.45,
    ...
  },
  "percentiles": {...},
  "gap_analysis": {
    "strategic_findings": [...],
    "executive_briefing": "..."
  },
  "roadmap": {
    "phase_1": [...],
    "phase_2": [...],
    "phase_3": [...]
  }
}
```

#### 3.2 Frontend Components
**Location**: `Application_Prototype/mvp_v1/frontend/src/components/results/`

**Component Mapping**:
- `ResultsHero.jsx` → Displays `total_score`, `cluster.cluster_name`
- `MaturityProfile.jsx` → Radar Chart using `dimension_scores` + `benchmark_scores`
- `ExecutiveBriefing.jsx` → Displays `gap_analysis.executive_briefing`
- `GapAnalysis.jsx` → Displays `gap_analysis.strategic_findings`
- `Roadmap.jsx` → Displays `roadmap.phase_1/2/3`
- `ClusterInsight.jsx` → Displays `cluster` information

---

## Key ML Components Explained

### 1. Clustering (Maturity Segmentation)
**Model**: KMeans (5 clusters)
**Purpose**: Categorize companies into maturity stages
**Clusters**:
1. Traditionalist (Low maturity)
2. Explorer (Early adoption)
3. Builder (Active development)
4. Scaler (Scaling AI)
5. Leader (AI-native)

### 2. Strategic Gap Analysis
**Algorithm**: Rule-based heuristics
**Logic**:
- **Structural Imbalance**: High variance across dimensions (σ > 1.0)
- **Critical Gap**: Low score (<2.5) + High strategic importance
**Output**: Top 2 prioritized gaps with impact scores

### 3. Roadmap Generation
**Model**: KNN (15 neighbors)
**Purpose**: Find similar companies and recommend next steps
**Logic**:
- **Strategic Gaps** → Phase 1 (immediate priorities)
- **Growth Opportunities** (peer comparison) → Phase 2
- **Advanced capabilities** → Phase 3

### 4. Peer Benchmarking
**Model**: KNN (15 neighbors)
**Purpose**: Realistic peer comparison for Radar Chart
**Scope**: **Global** (not industry-filtered)
**Process**: Find 15 most similar companies → Average their dimension scores

---

## Data Dependencies

### Training Data Sources
1. **Historical Assessments**: Company questionnaire responses
2. **Industry Benchmarks**: Aggregated industry statistics
3. **Dimension Calculations**: Derived from questionnaire answers

### Runtime Data Sources
1. **Database** (`backend/database.py`):
   - Company profiles
   - Questionnaire responses
   - Dimension scores (calculated on-the-fly)

2. **Cached Models** (`model_artifacts/v5/*.pkl`):
   - Pre-trained ML models
   - Industry benchmark data
   - Training dimension data (for KNN peer matching)

---

## Model Versioning

### Current Version: **ml_v5**
**Active Path**: `benchmarking_ai/ml_v5/`

### Previous Versions (if any)
**Legacy Path**: `models/` (not currently used)

**Migration**: The system exclusively uses `ml_v5`. Any models in `models/` are legacy.

---

## Summary

### Active Folders
1. ✅ **`benchmarking_ai/ml_v5/`** - Production ML system
   - Models: `models.py`, `inference.py`
   - Artifacts: `model_artifacts/v5/*.pkl`

2. ❌ **`models/`** - Legacy/unused

### Data Flow
```
Training Data
    ↓
[Offline Training] → model_artifacts/v5/*.pkl
    ↓
[Backend API] → InferenceEngine.run_analysis()
    ↓
[ML Pipeline] → Clustering + Gap Analysis + Roadmap
    ↓
[API Response] → JSON results
    ↓
[Frontend Components] → React UI rendering
```

### Key Integration Points
- **Backend Entry**: `backend/routers/results.py::get_results()`
- **ML Orchestrator**: `benchmarking_ai/ml_v5/inference.py::InferenceEngine`
- **Frontend Entry**: `frontend/src/pages/ResultsDashboard.jsx`
