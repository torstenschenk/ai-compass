@echo off
setlocal

echo ==========================================
echo Starting AI-Compass Prototype
echo ==========================================

set BASE_DIR=%~dp0
cd /d %BASE_DIR%

:: Check if setup was run
if not exist "backend\.venv" (
    echo Error: Backend virtual environment not found. Please run setup.bat first.
    pause
    exit /b 1
)

if not exist "frontend\node_modules" (
    echo Error: node_modules not found. Please run setup.bat first.
    pause
    exit /b 1
)

echo Launching Backend (FastAPI)...
start "AI-Compass Backend" cmd /k "cd /d backend && .venv\Scripts\activate && uvicorn main:app --reload --port 8000"

echo Launching Frontend (Vite)...
start "AI-Compass Frontend" cmd /k "cd /d frontend && npm run dev"

echo.
echo ==========================================
echo Application is starting!
echo Backend API Docs: http://localhost:8000/docs
echo Frontend URL:      http://localhost:5173
echo ==========================================
echo Keep this window open or use stop.bat to close the application.
