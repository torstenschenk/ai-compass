from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from datetime import datetime
from database import get_db
from models import Response, ResponseItem, Company
from schemas import response as schemas
from services.session_store import session_store
from sqlalchemy import func

router = APIRouter()

@router.post("/", response_model=schemas.ResponseDetail)
def create_response(response: schemas.ResponseCreate, db: Session = Depends(get_db)):
    """
    Initialize a new assessment response for a company.
    """
    new_response = session_store.create_response(response)
    return new_response

@router.patch("/{response_id}/items", response_model=schemas.ResponseDetail)
def save_answer(response_id: int, item: schemas.ResponseUpdate, db: Session = Depends(get_db)):
    """
    Save or update an answer (Autosave).
    """
    # Save to session store
    session_store.save_answer(response_id, item.question_id, item.answer_ids)
    
    # Return response details (mocked or retrieved from session)
    # Ideally should return the full response object, but ensuring schema match
    response_data = session_store.get_response(response_id)
    if not response_data:
         raise HTTPException(status_code=404, detail="Response not found")
         
    return response_data

@router.post("/{response_id}/complete")
def complete_assessment(response_id: int, db: Session = Depends(get_db)):
    """
    Mark assessment as complete, persist data to DB, and trigger scoring/analysis.
    """
    # 1. Retrieve full session data
    session_data = session_store.get_full_session(response_id)
    if not session_data:
        raise HTTPException(status_code=404, detail="Response session not found")
        
    company_data = session_data["company"]
    response_data = session_data["response"]
    items_data = session_data["items"]
    
    if not items_data:
        raise HTTPException(status_code=400, detail="Cannot complete assessment: No answers provided.")
    
    try:
        # 2. Persist Company
        # Check if ID exists (shouldn't if logic is correct, but safe to check or merge)
        # Using the ID from session to match the generated valid ID
        db_company = Company(
            company_id=company_data["company_id"],
            company_name=company_data["company_name"],
            industry=company_data["industry"],
            website=company_data["website"],
            number_of_employees=company_data["number_of_employees"],
            city=company_data["city"],
            email=company_data["email"]
        )
        db.merge(db_company) # merge handles insert or update if exists
        
        # 3. Persist Response
        db_response = Response(
            response_id=response_data["response_id"],
            company_id=response_data["company_id"],
            created_at=response_data["created_at"],
            total_score=response_data["total_score"],
            cluster_id=response_data["cluster_id"]
        )
        db.merge(db_response)
        
        # 4. Persist Response Items
        # Need to generate item_ids manually as they are not unique in session (0)
        # Get current max item_id
        max_item_id = db.query(func.max(ResponseItem.item_id)).scalar() or 0
        
        for item in items_data:
            max_item_id += 1
            db_item = ResponseItem(
                item_id=max_item_id,
                response_id=item["response_id"],
                question_id=item["question_id"],
                answers=item["answers"] # SQLAlchemy handles list -> ARRAY conversion
            )
            db.add(db_item)
            
        db.commit()
        
    except Exception as e:
        db.rollback()
        print(f"Error persisting session data: {e}")
        raise HTTPException(status_code=500, detail=f"Failed to persist assessment data: {str(e)}")

    return {"message": "Assessment completed and saved", "response_id": response_id}
