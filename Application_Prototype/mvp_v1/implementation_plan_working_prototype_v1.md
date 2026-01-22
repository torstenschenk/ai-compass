# AI-Compass v1 Working Prototype - Implementation Plan

---


---

## Executive Summary

This implementation plan outlines the development of a **v1 working prototype** for AI-Compass, an AI maturity assessment and benchmarking platform for SMEs. The prototype integrates existing ML v5 models, database infrastructure, and creates a complete end-to-end user experience from assessment to results delivery.

---

## Current State Analysis

### ✅ Completed Components

#### 1. **Database Infrastructure** (PostgreSQL on Supabase)
- **Connection**: `db.vxlbohrtynivparbdahm.supabase.co:5432`
- **Core Tables**:
  - `companies` - Company profiles (industry, size, location)
  - `responses` - Assessment responses with scores and cluster assignments
  - `response_items` - Individual question answers (array of answer IDs)
  - `questions` - Question bank with weights and types
  - `answers` - Answer options with weights (1-5 scale)
  - `dimensions` - 7 AI maturity dimensions with weights
  - `cluster_profiles` - 5 cluster archetypes (Traditionalist → AI-Driven Leader)

#### 2. **ML v5 Intelligence Engine** (`benchmarking_ai/ml_v5/`)
- **ClusterEngine**: K-Means clustering (5 archetypes) with PCA visualization + industry percentile calculation
- **StrategicGapAnalyzer**: Identifies structural imbalances and high-impact weaknesses
- **RoadmapGenerator**: 3-phase transformation roadmap with detailed explanations
- **DataPipeline**: Fetches and transforms DB data into ML-ready matrices
- **Trained Models**: Saved in `model_artifacts/v5/` directory

#### 3. **API Layer** (`models/`)
- **AICompassAPI** (`ai_compass_api.py`): Production-ready API that:
  - Loads trained ML v5 models
  - Fetches company data via DataPipeline
  - Generates comprehensive analysis (cluster, gaps, roadmap)
  - Returns JSON formatted for frontend consumption
  - Includes industry percentile rankings

#### 4. **Data Schemas** (`app/`)
- **Pydantic Models** (`schema.py`):
  - `Gui_Questions`: Questionnaire structure for frontend
  - `Gui_Response`: User response format
  - `Gui_Report`: Report data structure

#### 5. **Documentation** (`doc/`, `implementation/`)
- **Scoring Methodology**: Weighted averaging on 1-5 scale
- **User Journey**: Complete flow from landing → assessment → results → PDF
- **UI Specifications**: Detailed specs for all pages (landing, survey, results)

---

## Required Features for v1 Prototype

### 🟢 Requirements to Build

#### 1. **Frontend Application** (React/Next.js)
- Landing page with value proposition
- Company snapshot form
- Assessment wizard (one question per screen)
- Results dashboard with visualizations
- PDF export functionality

#### 2. **Backend API** (FastAPI)
- Questionnaire endpoint (`GET /api/v1/questionnaire`)
- Company creation endpoint (`POST /api/v1/companies`)
- Response management endpoints
- Assessment completion endpoint
- Results retrieval endpoint
- PDF generation endpoint

#### 3. **Integration Layer**
- Connect frontend to FastAPI backend
- Connect FastAPI to ML v5 models
- Connect FastAPI to PostgreSQL database

#### 4. **Execution Environment**
- Local environment setup (Python/Node.js)
- Startup scripts (`start.sh` / `start.bat`)
- Environment configuration (`.env`)
- Docker (Optional/Future)

---

## Proposed Implementation Plan

### Phase 1: Backend API Development (Foundation)

#### Component 1.1: FastAPI Application Structure
**Location**: `Application_Prototype/backend/`

**Files to Create**:
```
backend/
├── main.py                    # FastAPI app entry point
├── config.py                  # Environment configuration
├── database.py                # DB connection management
├── models/                    # SQLAlchemy ORM models
│   ├── __init__.py
│   ├── company.py
│   ├── response.py
│   ├── question.py
│   └── dimension.py
├── schemas/                   # Pydantic request/response schemas
│   ├── __init__.py
│   ├── questionnaire.py
│   ├── company.py
│   ├── response.py
│   └── results.py
├── routers/                   # API route handlers
│   ├── __init__.py
│   ├── questionnaire.py
│   ├── companies.py
│   ├── responses.py
│   └── results.py
├── services/                  # Business logic layer
│   ├── __init__.py
│   ├── scoring_service.py
│   ├── ml_service.py          # Integration with ml_v5
│   └── pdf_service.py
└── requirements.txt
```

**Key Endpoints**:
1. `GET /api/v1/questionnaire` - Load questions from DB
2. `POST /api/v1/companies` - Create company profile
3. `POST /api/v1/responses` - Create new response
4. `PATCH /api/v1/responses/{id}/items` - Save answer (autosave)
5. `POST /api/v1/responses/{id}/complete` - Finalize assessment
6. `GET /api/v1/responses/{id}/results` - Get analysis results
7. `GET /api/v1/responses/{id}/pdf` - Generate PDF report

**Integration Points**:
- Import from `../../benchmarking_ai/ml_v5/` for ML models
- Import from `../../models/ai_compass_api.py` for analysis logic
- Use existing database connection from `../../.env`

---

#### Component 1.2: ML Service Integration
**File**: `backend/services/ml_service.py`

**Purpose**: Wrapper around existing `AICompassAPI` from `models/ai_compass_api.py`

**Key Methods**:
```python
class MLAnalysisService:
    def __init__(self):
        self.api = AICompassAPI(models_path="../../benchmarking_ai/ml_v5/model_artifacts/v5")
    
    def generate_analysis(self, company_id: int, response_id: int) -> dict:
        """Calls existing AICompassAPI.generate_analysis()"""
        return self.api.generate_analysis(company_id, response_id)
```

---

#### Component 1.3: Scoring Service
**File**: `backend/services/scoring_service.py`

**Purpose**: Implement scoring methodology from `doc/scoring_methodology.md`

**Key Methods**:
- `calculate_question_score(question_type, selected_weights, question_weight)`
- `calculate_dimension_score(question_scores, question_weights)`
- `assign_cluster(dimension_scores)` - Uses ML v5 ClusterEngine

**References**: 
- Logic from `benchmarking_ai/ml_v5/data_pipeline.py` (lines 107-178)
- Methodology from `doc/scoring_methodology.md`

---

#### Component 1.4: PDF Generation Service
**File**: `backend/services/pdf_service.py`

**Technology**: ReportLab or WeasyPrint

**Content Structure** (from `implementation/0-USER-Journey.md`):
1. Title page (company name, date)
2. Overall score + cluster profile + percentile
3. Cluster profile bar chart
4. Multi-dimensional radar chart (7 dimensions)
5. Strategic gap analysis
6. 3-phase roadmap
7. Expert consultation CTA
8. Footer with version info

---

### Phase 2: Frontend Application Development

#### Component 2.1: React Application Structure (Vite)
**Location**: `Application_Prototype/frontend/`

**Files to Create**:
```
frontend/
├── src/
│   ├── main.jsx              # App entry point
│   ├── App.jsx               # Root component with routing
│   ├── pages/
│   │   ├── Landing.jsx       # Landing page
│   │   ├── CompanySnapshot.jsx # Company snapshot form
│   │   ├── AssessmentWizard.jsx # Assessment wizard
│   │   └── Results.jsx       # Results dashboard
│   ├── components/
│   │   ├── landing/
│   │   │   ├── Hero.jsx
│   │   │   ├── ValueProposition.jsx
│   │   │   ├── ThreeStepProcess.jsx
│   │   │   └── OutcomePreview.jsx
│   │   ├── assessment/
│   │   │   ├── ProgressBar.jsx
│   │   │   ├── QuestionCard.jsx
│   │   │   ├── NavigationButtons.jsx
│   │   │   └── AutosaveIndicator.jsx
│   │   ├── results/
│   │   │   ├── ScoreHeader.jsx
│   │   │   ├── ClusterProfile.jsx
│   │   │   ├── RadarChart.jsx
│   │   │   ├── GapAnalysis.jsx
│   │   │   ├── Roadmap.jsx
│   │   │   └── PDFDownload.jsx
│   │   └── ui/               # Reuse from implementation/ui/
│   ├── lib/
│   │   ├── api.js            # API client
│   │   └── utils.js          # Helper functions
│   ├── hooks/                # Custom React hooks
│   │   ├── useAutosave.js
│   │   └── useAssessment.js
│   └── styles/
│       └── index.css         # Global styles + Tailwind
├── public/
├── index.html
├── vite.config.js
├── package.json
└── jsconfig.json             # For better IDE support (path aliases, etc.)
```

**Language**: JavaScript (ES6+) with JSDoc comments for documentation
**Routing**: React Router v6
**Build Tool**: Vite (faster than CRA, modern tooling)

**UI Component Reuse**:
- Copy components from `implementation/ui/` (48 shadcn/ui components available)
- Adapt specifications from `implementation/*.md` files

---

#### Component 2.2: Key Pages Implementation

**Landing Page** (`src/pages/Landing.jsx`)
- Route: `/`
- Specifications: `implementation/1-Landingpage.md`
- Components: Hero, Value Prop, 3-Step Process, CTA
- Design: Premium, modern, vibrant (as per web dev guidelines)
- Navigation: "Start Assessment" → `/assessment/snapshot`

**Company Snapshot** (`src/pages/CompanySnapshot.jsx`)
- Route: `/assessment/snapshot`
- Specifications: `implementation/4-Company-Snapshot.md`
- Fields: Company Name, Industry (dropdown), Website, Employee Band, City
- Validation: Required fields before proceeding
- Navigation: On submit → `/assessment/wizard`

**Assessment Wizard** (`src/pages/AssessmentWizard.jsx`)
- Route: `/assessment/wizard`
- Specifications: `implementation/6-Survey.md`
- Features:
  - One question per screen
  - Progress bar (7 dimensions)
  - Async autosave with status indicator
  - Back/Next navigation
  - "Finish" button on last question
- Navigation: On complete → `/results/:responseId`

**Results Dashboard** (`src/pages/Results.jsx`)
- Route: `/results/:responseId`
- Specifications: `implementation/8.0-Results-Page.md` through `8.7-Download-Report.md`
- Sections:
  - Header with overall score
  - Cluster profile visualization
  - Radar chart (7 dimensions)
  - Strategic gap analysis
  - 3-phase roadmap
  - PDF download button

---

#### Component 2.3: Data Visualization
**Libraries**: 
- Recharts or Chart.js for radar charts
- D3.js for cluster visualization (PCA coordinates)

**Charts to Implement**:
1. **Radar Chart**: 7 dimensions (user vs peer average)
2. **Bar Chart**: Cluster profile comparison
3. **Scatter Plot**: PCA cluster visualization (optional for v1)

**Data Source**: 
- JSON response from `GET /api/v1/responses/{id}/results`
- Format matches `benchmarking_ai/ml_v5/sample_frontend_response.json`

---

### Phase 3: Integration & Testing

#### Component 3.1: API Integration
**File**: `frontend/src/lib/api.js`

**API Client Methods**:
```javascript
const API_BASE_URL = import.meta.env.VITE_API_URL || 'http://localhost:8000';

/**
 * API client for AI-Compass backend
 */
export const api = {
  getQuestionnaire: () => fetch(`${API_BASE_URL}/api/v1/questionnaire`),
  
  createCompany: (data) => fetch(`${API_BASE_URL}/api/v1/companies`, { 
    method: 'POST', 
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(data) 
  }),
  
  createResponse: (companyId) => fetch(`${API_BASE_URL}/api/v1/responses`, { 
    method: 'POST', 
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ company_id: companyId }) 
  }),
  
  saveAnswer: (responseId, questionId, answerIds) => fetch(`${API_BASE_URL}/api/v1/responses/${responseId}/items`, { 
    method: 'PATCH',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ question_id: questionId, answer_ids: answerIds })
  }),
  
  completeAssessment: (responseId) => fetch(`${API_BASE_URL}/api/v1/responses/${responseId}/complete`, { 
    method: 'POST' 
  }),
  
  getResults: (responseId) => fetch(`${API_BASE_URL}/api/v1/responses/${responseId}/results`),
  
  downloadPDF: (responseId) => fetch(`${API_BASE_URL}/api/v1/responses/${responseId}/pdf`)
};
```

**Custom Hooks** (`src/hooks/`):
- `useAutosave.js`: Handles debounced autosave with retry logic
- `useAssessment.js`: Manages assessment state and progress

---

#### Component 3.2: State Management
**Approach**: React Context API (built-in, no extra dependencies)

**Context Providers** (`src/context/`):
- `AssessmentContext.jsx`: Manages assessment flow state
- `CompanyContext.jsx`: Stores company and response IDs

**State to Manage**:
- Current company ID
- Current response ID
- Questionnaire data (cached in sessionStorage)
- Assessment progress (current question index)
- Autosave status (saving/saved/error)

**Note**: Use JSDoc comments for better IDE support and documentation

---

#### Component 3.3: Testing Strategy

**Backend Tests**:
1. Unit tests for scoring logic
2. Integration tests for ML service
3. API endpoint tests (FastAPI TestClient)

**Frontend Tests**:
1. Component tests (React Testing Library)
2. E2E tests (Playwright) - Optional for v1

**Manual Testing Checklist**:
- [ ] Complete assessment flow (landing → wizard → results)
- [ ] Autosave functionality
- [ ] Score calculation accuracy (compare with `benchmarking_ai/ml_v5/verify_representatives.py`)
- [ ] PDF generation
- [ ] Responsive design (desktop + mobile)

---

### Phase 4: Execution & Delivery

#### Component 4.1: Local Execution Setup
**Goal**: Run application locally on localhost

**Files to Create**:
```
Application_Prototype/mvp_v1/
├── start.sh                   # Linux/Mac startup
├── start.bat                  # Windows startup
└── readme_run_locally.md      # Instructions
```

**Services (Localhost)**:
1. **Backend**: FastAPI (http://localhost:8000)
2. **Frontend**: React + Vite (http://localhost:5173)
3. **Database**: PostgreSQL (Supabase remote connection)

---

#### Component 4.2: Environment Configuration
**Backend** (`.env`):
```
DATABASE_URL=postgresql://postgres:aicompass-pass@db.vxlbohrtynivparbdahm.supabase.co:5432/postgres
ML_MODELS_PATH=../benchmarking_ai/ml_v5/model_artifacts/v5
CORS_ORIGINS=http://localhost:5173
```

**Frontend** (`.env`):
```
VITE_API_URL=http://localhost:8000
```

---

#### Component 4.3: Startup Scripts
**File**: `Application_Prototype/mvp_v1/start.bat` (Windows)
```batch
@echo off
echo Starting AI-Compass v1 Prototype...

:: Start Backend
start "AI-Compass Backend" cmd /k "cd backend && uvicorn main:app --reload --port 8000"

:: Start Frontend
start "AI-Compass Frontend" cmd /k "cd frontend && npm run dev"

echo Backend running at http://localhost:8000/docs
echo Frontend running at http://localhost:5173
```

---

## Implementation Sequence

### Week 1: Backend Foundation
1. Set up FastAPI project structure
2. Create database models (SQLAlchemy)
3. Implement questionnaire endpoint
4. Implement company creation endpoint
5. Test DB connectivity with existing Supabase instance

### Week 2: Backend Core Logic
1. Implement scoring service (from `doc/scoring_methodology.md`)
2. Integrate ML v5 models (wrapper around `models/ai_compass_api.py`)
3. Implement response management endpoints
4. Implement results endpoint
5. Test with existing company data (company_id=46)

### Week 3: Frontend Core
1. Set up React + Vite project with JavaScript
2. Configure React Router v6 and jsconfig.json
3. Build landing page (from `implementation/1-Landingpage.md`)
4. Build company snapshot form
5. Build assessment wizard (one-question-per-screen)
6. Implement autosave functionality with custom hooks

### Week 4: Frontend Results & Polish
1. Build results dashboard
2. Implement radar chart and visualizations
3. Integrate with backend API
4. Add loading states and error handling
5. Responsive design adjustments

### Week 5: PDF & Integration
1. Implement PDF generation service
2. End-to-end testing
3. Bug fixes and refinements
4. Documentation updates
5. Deployment preparation

---

## Success Criteria

### Functional Requirements
- [ ] User can complete full assessment (7 dimensions, ~30 questions)
- [ ] System calculates scores using weighted methodology
- [ ] ML v5 models generate cluster assignment, gap analysis, and roadmap
- [ ] Results page displays all analysis components
- [ ] PDF export works with complete report
- [ ] Industry percentile calculation works

### Technical Requirements
- [ ] Backend API responds within 500ms (excluding ML inference)
- [ ] ML inference completes within 3 seconds
- [ ] Frontend loads within 2 seconds
- [ ] Autosave works reliably with retry logic
- [ ] Database queries are optimized (indexed)

### User Experience Requirements
- [ ] Landing page is visually impressive (premium design)
- [ ] Assessment wizard is intuitive (one question at a time)
- [ ] Progress is always visible
- [ ] Results are easy to understand
- [ ] PDF is professional and shareable

---

## Risk Mitigation

### Risk 1: ML Model Integration Complexity
**Mitigation**: Use existing `AICompassAPI` as-is; it's already production-ready

### Risk 2: PDF Generation Performance
**Mitigation**: Generate PDFs asynchronously; return download link

### Risk 3: Database Performance
**Mitigation**: Use existing indexes; add caching for questionnaire data

### Risk 4: Frontend State Management
**Mitigation**: Keep state simple; use React Context for global state

---

## Dependencies & Prerequisites

### Required from Existing Codebase
1. ✅ `benchmarking_ai/ml_v5/` - ML models (already trained)
2. ✅ `models/ai_compass_api.py` - API wrapper (already implemented)
3. ✅ Database schema (already deployed on Supabase)
4. ✅ `doc/scoring_methodology.md` - Scoring logic
5. ✅ `implementation/*.md` - UI specifications
6. ✅ `implementation/ui/` - UI components (shadcn/ui)

### New Dependencies to Install
**Backend**:
- FastAPI
- SQLAlchemy
- psycopg2-binary
- python-dotenv
- reportlab (PDF generation)
- uvicorn

**Frontend**:
- React 18+
- Vite 5+
- React Router v6
- Recharts (charts)
- shadcn/ui (already available in `implementation/ui/`)
- TailwindCSS
- PropTypes (optional, for runtime type checking)

---

## File Structure Overview

```
Application_Prototype/
├── implementation_plan_working_prototype.md  # This file
├── backend/                                  # FastAPI backend
│   ├── main.py
│   ├── config.py
│   ├── database.py
│   ├── models/                              # SQLAlchemy ORM
│   ├── schemas/                             # Pydantic schemas
│   ├── routers/                             # API endpoints
│   ├── services/                            # Business logic
│   │   ├── scoring_service.py              # From doc/scoring_methodology.md
│   │   ├── ml_service.py                   # Wraps models/ai_compass_api.py
│   │   └── pdf_service.py
│   ├── Dockerfile
│   └── requirements.txt
├── frontend/                                 # React + Vite frontend
│   ├── src/
│   │   ├── main.jsx                        # App entry point
│   │   ├── App.jsx                         # Root with React Router
│   │   ├── pages/
│   │   │   ├── Landing.jsx                 # From implementation/1-Landingpage.md
│   │   │   ├── CompanySnapshot.jsx         # From implementation/4-Company-Snapshot.md
│   │   │   ├── AssessmentWizard.jsx        # From implementation/6-Survey.md
│   │   │   └── Results.jsx                 # From implementation/8.0-Results-Page.md
│   │   ├── components/
│   │   │   ├── ui/                         # From implementation/ui/
│   │   │   ├── landing/
│   │   │   ├── assessment/
│   │   │   └── results/
│   │   ├── hooks/                          # Custom React hooks
│   │   ├── context/                        # React Context providers
│   │   ├── lib/
│   │   │   ├── api.js                      # API client
│   │   │   └── utils.js
│   │   └── styles/
│   ├── public/
│   ├── index.html
│   ├── vite.config.js
│   ├── jsconfig.json                       # For IDE support
│   ├── Dockerfile
│   └── package.json
├── docker-compose.yml
└── start.sh
```

---

## Next Steps

1. **Review & Approval**: Review this implementation plan
2. **Backend Development**: Start with Phase 1 (FastAPI setup)
3. **Frontend Development**: Parallel development of Phase 2
4. **Integration**: Connect frontend to backend (Phase 3)
5. **Deployment**: Containerize and deploy (Phase 4)

---

## References

### Analyzed Components
- **Database**: `.env` (Supabase PostgreSQL)
- **ML Models**: `benchmarking_ai/ml_v5/` (ClusterEngine, GapAnalyzer, RoadmapGenerator)
- **API**: `models/ai_compass_api.py`
- **Schemas**: `app/schema.py`
- **Documentation**: `doc/scoring_methodology.md`, `implementation/*.md`
- **Setup**: `setup/requirements.txt`, `setup/readme_sql_connection.md`

### Key Files Referenced
1. `benchmarking_ai/ml_v5/models.py` - ML model implementations
2. `benchmarking_ai/ml_v5/data_pipeline.py` - Data transformation logic
3. `benchmarking_ai/ml_v5/sample_frontend_response.json` - Expected API response format
4. `models/ai_compass_api.py` - Production API wrapper
5. `implementation/0-USER-Journey.md` - Complete user flow
6. `implementation/aic-db-struct-dump.sql` - Database schema
7. `doc/scoring_methodology.md` - Scoring calculation rules

---

**Version**: 1.0  
**Date**: 2026-01-21  
**Status**: Ready for Review
