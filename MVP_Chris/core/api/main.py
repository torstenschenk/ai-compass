from fastapi import FastAPI, HTTPException
from fastapi.responses import StreamingResponse
from core.services.report_service import generate_pdf_report
from fastapi.middleware.cors import CORSMiddleware
import asyncio
import os

app = FastAPI(title="AI Compass API")

# CORS Setup
allowed_origins_env = os.getenv("ALLOWED_ORIGINS")
if allowed_origins_env:
    origins = allowed_origins_env.split(",")
else:
    # Default for development
    origins = [
        "http://localhost:5173",
        "http://127.0.0.1:5173",
        "http://localhost:3000",
        "http://127.0.0.1:3000",
    ]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.get("/")
async def root():
    return {"message": "AI Compass API is running (CSV Mode)"}

@app.on_event("startup")
async def startup():
    print("Backend started in CSV Mode. Database usage skipped.")

@app.get("/api/v1/questionnaire")
async def get_questionnaire():
    from core.services.questionnaire_service import get_full_questionnaire
    return await get_full_questionnaire()

from core.api.schemas import ResponseCreate, ResponseItemsBatch, TokenResponse, ResponseRead
from core.services.response_service import create_new_response, save_response_items, calculate_and_complete_response, get_response_summary

@app.post("/api/v1/responses", response_model=TokenResponse)
async def create_response_endpoint(data: ResponseCreate):
    return await create_new_response(data.company.dict())

@app.post("/api/v1/responses/{response_id}/items")
async def save_items_endpoint(response_id: int, batch: ResponseItemsBatch):
    success = await save_response_items(response_id, [item.dict() for item in batch.items])
    if not success:
        return {"ok": False, "error": "Response not found"}
    return {"ok": True, "saved_count": len(batch.items)}

@app.post("/api/v1/responses/{response_id}/complete")
async def complete_response_endpoint(response_id: int):
    result = await calculate_and_complete_response(response_id)
    if not result:
         return {"ok": False, "error": "Response not found or empty"}
    return {"ok": True, "result": result}

@app.get("/api/v1/responses/{response_id}", response_model=ResponseRead)
async def get_response_endpoint(response_id: int):
    response = await get_response_summary(response_id)
    if not response:
         raise HTTPException(status_code=404, detail="Response not found")
    return response

@app.get("/api/v1/responses/{response_id}/report")
async def get_response_report(response_id: int):
    data = await get_response_summary(response_id)
    if not data:
        raise HTTPException(status_code=404, detail="Response not found")
        
    pdf_buffer = generate_pdf_report(data)
    
    return StreamingResponse(
        pdf_buffer, 
        media_type="application/pdf",
        headers={"Content-Disposition": f"attachment; filename=ai_compass_report_{response_id}.pdf"}
    )
