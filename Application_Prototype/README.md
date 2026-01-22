# AI-Compass Application Prototype (mvp_v1)

This directory contains the **v1 Working Prototype** of AI-Compass. It is a full-stack platform designed to provide SMEs (Mittelstand) with an automated AI maturity assessment, industry benchmarking, and a strategic transformation roadmap.

---

## 🚀 Overview

The prototype transforms traditional manual consulting into a scalable digital experience. It guides users through an assessment across 7 dimensions of AI maturity, processes their input using a trained **ML v5 Intelligence Engine**, and delivers a high-fidelity visual report.

### Core Value Proposition
- **Explainable Maturity**: Scores from 1 to 5 across 7 core dimensions.
- **Accurate Benchmarking**: Comparative analysis against 5 semantic archetypes (Traditionalist → AI-Driven Leader).
- **Actionable Roadmap**: A phased (90/180/360 days) roadmap derived from strategic gap analysis.

---

## 🛠 Technology Stack

### Frontend
- **Framework**: React 18 with Vite
- **Styling**: Tailwind CSS + shadcn/ui (Premium components)
- **State Management**: React Context API
- **Visualizations**: Recharts (Radar charts, Bar charts)
- **Routing**: React Router v6

### Backend
- **Framework**: FastAPI (Python 3.10+)
- **ORM**: SQLAlchemy (PostgreSQL integration)
- **Data Validation**: Pydantic v2
- **Persistence**: PostgreSQL (hosted on Supabase)
- **In-Memory Store**: Custom session store for autosave and temporary state tracking.

### Intelligence (ML v5)
- **ClusterEngine**: K-Means clustering (5 archetypes) with PCA visualization.
- **StrategicGapAnalyzer**: Identifies structural imbalances in company maturity.
- **RoadmapGenerator**: Generates prioritized transformation steps.
- **Inference Engine**: Dedicated wrapper in `benchmarking_ai/ml_v5/inference.py` for real-time analysis.

---

## 📂 Project Structure

```text
Application_Prototype/mvp_v1/
├── backend/                # FastAPI Application Layer
│   ├── main.py             # Server entry point & Middleware config
│   ├── database.py         # SQLAlchemy engine & dependency injection
│   ├── models/             # Database ORM models (Company, Response, etc.)
│   ├── schemas/            # Pydantic request/response models
│   ├── routers/            # API endpoints (Questionnaire, Responses, Results)
│   ├── services/           # Business logic & Session management
│   └── requirements.txt    # Python backend dependencies
├── frontend/               # React Application Layer
│   ├── src/
│   │   ├── components/     # UI components (UI, Results, Assessment)
│   │   ├── pages/          # Full page views (Landing, Wizard, Results)
│   │   ├── hooks/          # Custom hooks (Autosave, Assessment flow)
│   │   ├── lib/            # API client (Axios/Fetch wrappers)
│   │   └── context/        # Global state providers
│   ├── package.json        # Node.js dependencies
│   └── tailwind.config.js  # Styling & theme configuration
├── setup.bat / .sh         # Automated environment setup scripts
├── start.bat / .sh         # One-click launch scripts
└── stop.bat / .sh          # Safe termination scripts
```

---

## 📋 Key Features & Logic

### 1. Assessment Wizard
- **One-Question-Per-Screen**: Minimizes cognitive load.
- **Automated Autosave**: Responses are saved locally to an in-memory session store on every change, ensuring zero data loss if the user refreshes.
- **Progress Tracking**: Real-time progress bar across 7 dimensions.

### 2. Scoring Methodology
- **Weighted Averaging**: Each question and dimension has specific weights defined in the DB.
- **Scale**: Normalized to a 1.0 - 5.0 scale for industry comparability.

### 3. Industry Benchmarking
- Uses **PCA (Principal Component Analysis)** to map the company into a multi-dimensional space.
- Assigns the company to one of 5 clusters based on its proximity to archetype centroids.
- Calculates **Industry Percentiles** comparing the user's score to the global dataset.

---

## ⚙️ Development Guide

### Environment Variables
Both frontend and backend require `.env` files. The `setup` scripts attempt to handle this, but for manual config:

**Backend (`backend/.env`)**:
```env
DATABASE_URL=postgresql://... (Supabase URL)
CORS_ORIGINS=["http://localhost:5173"]
```

**Frontend (`frontend/.env`)**:
```env
VITE_API_URL=http://localhost:8000
```

### Automation Scripts (Recommended)
- **Setup**: `setup.bat` (Win) or `./setup.sh` (Mac) - Installs Python venv, Pip deps, and Npm modules.
- **Start**: `start.bat` (Win) or `./start.sh` (Mac) - Runs both servers in parallel.
- **Stop**: `stop.bat` (Win) or `./stop.sh` (Mac) - Frees up ports 8000 and 5173.

---

## 📡 API Endpoints

- `GET /api/v1/questionnaire`: Fetches the full question bank with metadata.
- `POST /api/v1/companies`: Registers a new company profile.
- `POST /api/v1/responses`: Initializes an assessment session.
- `PATCH /api/v1/responses/{id}/items`: Updates individual question answers (Autosave).
- `POST /api/v1/responses/{id}/complete`: Finalizes the assessment and persists to DB.
- `GET /api/v1/responses/{id}/results`: Triggers ML analysis and returns the full report.

---

## 🔗 Documentation Links
- [Implementation Plan](implementation_plan_working_prototype_v1.md)
- [Scoring Methodology](../../doc/scoring_methodology.md)
- [ML v5 Explanation](../../model_explanation.md)
