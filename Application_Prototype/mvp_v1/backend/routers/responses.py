from fastapi import APIRouter, HTTPException
from schemas import response as schemas
from services.session_store import session_store
from services.scoring_service import calculate_total_score

router = APIRouter()

@router.post("/", response_model=schemas.ResponseDetail)
def create_response(response: schemas.ResponseCreate):
    """
    Initialize a new assessment response for a company.
    """
    new_response = session_store.create_response(response)
    return new_response

@router.patch("/{response_id}/items", response_model=schemas.ResponseDetail)
def save_answer(response_id: int, item: schemas.ResponseUpdate):
    """
    Save or update an answer (Autosave).
    """
    # Save to session store
    session_store.save_answer(response_id, item.question_id, item.answer_ids)
    
    # Return response details from session
    response_data = session_store.get_response(response_id)
    if not response_data:
         raise HTTPException(status_code=404, detail="Response not found")
         
    return response_data

@router.post("/{response_id}/complete")
def complete_assessment(response_id: int):
    """
    Mark assessment as complete and store in-memory.
    """
    # 1. Retrieve full session data
    session_data = session_store.get_full_session(response_id)
    if not session_data:
        raise HTTPException(status_code=404, detail="Response session not found")
        
    items_data = session_data["items"]
    
    if not items_data:
        raise HTTPException(status_code=400, detail="Cannot complete assessment: No answers provided.")
    
    try:
        # 2. Calculate actual total score based on answers (passing None for db)
        calculated_total_score = calculate_total_score(items_data, None)
        
        # 3. Store final record in SessionStore
        session_store.complete_assessment(
            response_id=response_id,
            total_score=calculated_total_score,
            cluster_id=session_data["response"]["cluster_id"]
        )
        
    except Exception as e:
        print(f"Error completing assessment: {e}")
        raise HTTPException(status_code=500, detail=f"Failed to complete assessment: {str(e)}")

    return {"message": "Assessment completed and stored in-memory", "response_id": response_id}

