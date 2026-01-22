# AI-Compass Application Prototype

This directory contains the **v1 Working Prototype** of the AI-Compass platform. It is a full-stack application integrating the ML v5 models with a React frontend and a FastAPI backend.

## Project Structure

```text
Application_Prototype/mvp_v1/
├── backend/                # FastAPI Application
│   ├── main.py             # Entry point
│   ├── models/             # Database ORM models
│   ├── routers/            # API endpoints
│   ├── services/           # Business logic & ML integration
│   └── requirements.txt    # Python dependencies
└── frontend/               # React + Vite Application
    ├── src/                # Source code (Pages, Components)
    ├── package.json        # Node.js dependencies
    └── tailwind.config.js  # Styling configuration
```

## Quick Start (Automated)

We provide cross-platform scripts in **this directory** to manage the application easily.

### 1. Setup
Install all dependencies (Python virtual environment and npm packages) and check configuration.
- **Windows:** Run `setup.bat`
- **Mac/Linux:** Run `./setup.sh` (Ensure it has execute permissions: `chmod +x setup.sh`)

### 2. Start
Launches both the backend and frontend servers simultaneously.
- **Windows:** Run `start.bat`
- **Mac/Linux:** Run `./start.sh`

### 3. Stop
Terminates the running processes on ports 8000 and 5173.
- **Windows:** Run `stop.bat`
- **Mac/Linux:** Run `./stop.sh`

---

## Manual Execution

If you prefer to run the components manually:

### Backend
1. `cd Application_Prototype/mvp_v1/backend`
2. `python -m venv .venv`
3. Activate environment:
   - Windows: `.venv\Scripts\activate`
   - Mac/Linux: `source .venv/bin/activate`
4. `pip install -r requirements.txt`
5. `uvicorn main:app --reload --port 8000`

### Frontend
1. `cd Application_Prototype/mvp_v1/frontend`
2. `npm install`
3. `npm run dev`

---

## Accessing the App
- **Web UI:** [http://localhost:5173](http://localhost:5173)
- **API Documentation:** [http://localhost:8000/docs](http://localhost:8000/docs)
