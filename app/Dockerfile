# --------- STAGE 1: Build Frontend ---------
FROM node:20-alpine AS frontend-build
WORKDIR /app/frontend

# Install dependencies first for better caching
COPY frontend/package*.json ./
RUN npm ci

# Copy the rest of the frontend code and build
COPY frontend/ ./
RUN npm run build


# --------- STAGE 2: Build Backend & Serve ---------
FROM python:3.12-slim
WORKDIR /app

# Ensure standard output is not buffered
ENV PYTHONUNBUFFERED=1

# Install backend dependencies first
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the backend code
COPY backend/ ./backend/

# Copy the compiled React static files from Stage 1 into the Python container
# They will be placed at /app/frontend/dist where FastAPI will serve them from
COPY --from=frontend-build /app/frontend/dist ./frontend/dist

# Copy the entrypoint script and make it executable
COPY entrypoint.sh ./
RUN chmod +x entrypoint.sh

# Expose the single port we need
EXPOSE 8000

# Start the application using the entrypoint script
CMD ["./entrypoint.sh"]
