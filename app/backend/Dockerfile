# Use an official Python runtime as a parent image
FROM python:3.12-slim
# Note: Choose the python version that matches your environment (.venv)

# Set the working directory in the container
WORKDIR /app

# Copy the requirements file into the container
# We assume the build context is the 'app' directory
COPY requirements.txt .

# Install any needed packages specified in requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Copy the backend directory contents into the container at /app
# We will effectively run from the backend directory to resolve the modules cleanly
COPY backend/ ./

# Expose port 8000 for FastAPI
EXPOSE 8000

# Run uvicorn server
# The module is main, the instance is app
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
