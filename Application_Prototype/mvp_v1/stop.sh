#!/bin/bash

echo "=========================================="
echo "Stopping AI-Compass Prototype Processes"
echo "=========================================="

# Kill processes on port 8000 (Backend)
PID_8000=$(lsof -t -i:8000)
if [ -n "$PID_8000" ]; then
    echo "Stopping Backend process (PID $PID_8000)..."
    kill -9 $PID_8000
fi

# Kill processes on port 5173 (Frontend)
PID_5173=$(lsof -t -i:5173)
if [ -n "$PID_5173" ]; then
    echo "Stopping Frontend process (PID $PID_5173)..."
    kill -9 $PID_5173
fi

echo ""
echo "Process cleanup complete."
