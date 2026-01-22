@echo off
setlocal

echo ==========================================
echo Setting up AI-Compass Prototype Environment (Windows)
echo ==========================================

set BASE_DIR=%~dp0
set ROOT_DIR=%BASE_DIR%..\..
cd /d %BASE_DIR%

echo [1/2] Verifying Root Virtual Environment...
if not exist "%ROOT_DIR%\.venv" (
    echo A root .venv was expected at %ROOT_DIR%\.venv but not found.
    echo Please ensure the project root has the virtual environment set up.
    echo You may need to run "python -m venv .venv" in the root folder: %ROOT_DIR%
    pause
    exit /b 1
)

echo Installing Python dependencies into ROOT .venv...
call "%ROOT_DIR%\.venv\Scripts\activate"
cd backend
pip install -r requirements.txt
cd %BASE_DIR%

echo.
echo [2/2] Setting up Frontend...
if not exist "frontend" (
    echo Error: Frontend directory not found.
    pause
    exit /b 1
)

cd frontend
if not exist "node_modules" (
    echo Installing npm dependencies...
    call npm install
) else (
    echo node_modules found, skipping install.
)
cd %BASE_DIR%

echo.
echo ==========================================
echo Setup Complete!
echo Use start.bat to run the application.
echo ==========================================
pause
