from fastapi import FastAPI
from contextlib import asynccontextmanager
import logging
from fastapi.middleware.cors import CORSMiddleware
from .config import get_settings
from .routers import api_router

@asynccontextmanager
async def lifespan(app: FastAPI):
    # Enable logging
    logging.basicConfig(
        level=logging.INFO,
        format="%(levelname)s: %(name)s: %(message)s"
    )
    
    yield

settings = get_settings()

app = FastAPI(
    title=settings.PROJECT_NAME,
    version=settings.VERSION,
    openapi_url=f"{settings.API_V1_STR}/openapi.json",
    lifespan=lifespan
)

# Include API Router
app.include_router(api_router, prefix=settings.API_V1_STR)

# Set all CORS enabled origins
if settings.CORS_ORIGINS:
    app.add_middleware(
        CORSMiddleware,
        allow_origins=settings.CORS_ORIGINS,
        allow_credentials=True,
        allow_methods=["*"],
        allow_headers=["*"],
    )

from pathlib import Path
from fastapi.responses import FileResponse

@app.get("/health")
def health_check():
    return {"status": "healthy"}

@app.get("/{full_path:path}")
async def serve_frontend(full_path: str):
    # Path inside the container (or local) where Vite builds the frontend
    dist_dir = Path("frontend/dist").resolve()
    requested_file = (dist_dir / full_path).resolve()
    
    # 1. Try serving the specific requested file (like /assets/style.css, /favicon.ico)
    # The `is_relative_to` check prevents path traversal attacks
    if dist_dir.exists() and requested_file.is_relative_to(dist_dir) and requested_file.is_file():
        return FileResponse(requested_file)
        
    # 2. Fallback to index.html to let React Router handle the route client-side
    index_file = dist_dir / "index.html"
    if index_file.is_file():
        return FileResponse(index_file)
        
    # 3. If no frontend is built yet, show a helpful message instead of crashing
    return {"message": "Frontend is not built. Run 'npm run build' in the frontend folder."}

# Touch to force reload - ML models updated

