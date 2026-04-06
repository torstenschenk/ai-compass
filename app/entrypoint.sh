#!/bin/bash

# Default to port 8000 if PORT environment variable is not set (e.g., by Cloud Run)
APP_PORT=${PORT:-8000}

# Run gunicorn with uvicorn workers
exec gunicorn backend.main:app -k uvicorn.workers.UvicornWorker --bind "0.0.0.0:${APP_PORT}"