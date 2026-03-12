@echo off
setlocal

echo Stopping AI-Compass Processes...

taskkill /FI "WINDOWTITLE eq AI-Compass Backend*" /T /F >nul 2>&1
taskkill /FI "WINDOWTITLE eq AI-Compass Frontend*" /T /F >nul 2>&1

:: Also try to kill independent node/python processes if they linger (optional/optimistic)
:: taskkill /IM node.exe /F >nul 2>&1
:: taskkill /IM python.exe /F >nul 2>&1

echo Done.
timeout /t 2 >nul
