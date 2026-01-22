@echo off
setlocal

echo ==========================================
echo Setting up AI-Compass Prototype Environment
echo ==========================================

:: Set current directory to the one containing this script
set BASE_DIR=%~dp0
cd /d %BASE_DIR%

echo [1/3] Setting up Backend...
if not exist "backend" (
    echo Error: Backend directory not found.
    exit /b 1
)

cd backend
if not exist .venv (
    echo Creating virtual environment...
    python -m venv .venv
)

echo Installing Python dependencies...
call .venv\Scripts\activate
pip install -r requirements.txt
if %errorlevel% neq 0 (
    echo Failed to install Python dependencies.
    exit /b 1
)
cd /d %BASE_DIR%

echo.
echo [2/3] Setting up Frontend...
if not exist "frontend" (
    echo Error: Frontend directory not found.
    exit /b 1
)

cd frontend
echo Installing npm dependencies (this may take a few minutes)...
:: node_modules is not in repo, so npm install is crucial
call npm install
if %errorlevel% neq 0 (
    echo Failed to install npm dependencies.
    exit /b 1
)
cd /d %BASE_DIR%

echo.
echo [3/3] Checking configuration...
:: Copy .env from root if it exists and backend/.env doesn't (checking relative to project root)
if not exist "backend\.env" (
    if exist "..\..\.env" (
        echo Copying .env from root to backend/...
        copy "..\..\.env" "backend\.env"
    ) else (
        echo WARNING: backend/.env not found. Please create it manually.
    )
)

:: Create frontend .env if missing
if not exist "frontend\.env" (
    echo Creating frontend/.env...
    echo VITE_API_URL=http://localhost:8000> "frontend\.env"
)

echo.
echo ==========================================
echo Setup Complete!
echo Use start.bat to run the application.
echo ==========================================
pause
