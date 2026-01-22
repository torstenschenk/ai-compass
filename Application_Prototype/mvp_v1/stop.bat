@echo off
setlocal

echo ==========================================
echo Stopping AI-Compass Prototype Processes
echo ==========================================

:: Find PID of process on port 8000 (Backend)
echo Stopping Backend (Port 8000)...
for /f "tokens=5" %%a in ('netstat -aon ^| findstr :8000 ^| findstr LISTENING') do (
    echo Killing process %%a
    taskkill /f /pid %%a
)

:: Find PID of process on port 5173 (Frontend)
echo Stopping Frontend (Port 5173)...
for /f "tokens=5" %%a in ('netstat -aon ^| findstr :5173 ^| findstr LISTENING') do (
    echo Killing process %%a
    taskkill /f /pid %%a
)

echo.
echo Process cleanup complete.
pause
