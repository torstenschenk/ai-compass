#!/bin/bash
set -e

echo "=========================================="
echo "Setting up AI-Compass Prototype Environment (Mac/Linux)"
echo "=========================================="

# get base dir
BASE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$BASE_DIR"

echo "[1/3] Setting up Backend..."
if [ ! -d "backend" ]; then
    echo "Error: Backend directory not found."
    exit 1
fi

cd backend
if [ ! -d ".venv" ]; then
    echo "Creating virtual environment..."
    python3 -m venv .venv
fi

echo "Installing Python dependencies..."
source .venv/bin/activate
pip install -r requirements.txt
cd "$BASE_DIR"

echo ""
echo "[2/3] Setting up Frontend..."
if [ ! -d "frontend" ]; then
    echo "Error: Frontend directory not found."
    exit 1
fi

cd frontend
echo "Installing npm dependencies (this may take a few minutes)..."
npm install
cd "$BASE_DIR"

echo ""
echo "[3/3] Checking configuration..."
if [ ! -f "backend/.env" ]; then
    if [ -f "../../.env" ]; then
        echo "Copying .env from root to backend/..."
        cp "../../.env" "backend/.env"
    else
        echo "WARNING: backend/.env not found. Please create it manually."
    fi
fi

if [ ! -f "frontend/.env" ]; then
    echo "Creating frontend/.env..."
    echo "VITE_API_URL=http://localhost:8000" > "frontend/.env"
fi

echo ""
echo "=========================================="
echo "Setup Complete!"
echo "Use ./start.sh to run the application."
echo "=========================================="
