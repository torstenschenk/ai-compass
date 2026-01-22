@echo off
setlocal

echo ==========================================
echo Starting AI-Compass Prototype
echo ==========================================

set BASE_DIR=%~dp0
set ROOT_DIR=%BASE_DIR%..\..
cd /d %BASE_DIR%

:: Check if root venv exists
if not exist "%ROOT_DIR%\.venv" (
    echo Error: Root virtual environment not found at %ROOT_DIR%\.venv
    echo Please ensure the project structure is correct.
    pause
    exit /b 1
)

if not exist "frontend\node_modules" (
    echo Error: node_modules not found. Please run setup.bat first.
    pause
    exit /b 1
)

echo Launching Backend (FastAPI)...
:: We activate the ROOT .venv, then start uvicorn from the backend folder
start "AI-Compass Backend" cmd /k "call "%ROOT_DIR%\.venv\Scripts\activate" && cd backend && uvicorn main:app --reload --port 8000 --env-file "%ROOT_DIR%\.env""

echo Launching Frontend (Vite)...
start "AI-Compass Frontend" cmd /k "cd /d frontend && npm run dev"

echo.
echo ==========================================
echo Application is starting!
echo Backend API Docs: http://localhost:8000/docs
echo Frontend URL:      http://localhost:5173
echo ==========================================
echo Keep this window open or use stop.bat to close the application.
