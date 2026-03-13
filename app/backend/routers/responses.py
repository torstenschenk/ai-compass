from fastapi import APIRouter, HTTPException
from schemas import response as schemas
from services.session_store import session_store
from services.scoring_service import calculate_total_score

router = APIRouter()

@router.post("", response_model=schemas.SessionDetail)
def create_session(session_data: schemas.SessionCreate):
    """
    Initialize a new assessment session.
    """
    new_session = session_store.create_session(session_data)
    return new_session

@router.patch("/{session_id}/items", response_model=schemas.SessionDetail)
def save_answer(session_id: int, item: schemas.ResponseUpdate):
    """
    Save or update an answer (Autosave).
    """
    # Save to session store
    session_store.save_answer(session_id, item.question_id, item.answer_ids)
    
    # Return session details from session
    session_data = session_store.get_session(session_id)
    if not session_data:
         raise HTTPException(status_code=404, detail="Session not found")
         
    return session_data

@router.post("/{session_id}/complete")
def complete_assessment(session_id: int):
    """
    Mark assessment as complete and store in-memory.
    """
    # 1. Retrieve full session data
    full_session = session_store.get_full_session(session_id)
    if not full_session:
        raise HTTPException(status_code=404, detail="Session not found")
        
    items_data = full_session["items"]
    
    if not items_data:
        raise HTTPException(status_code=400, detail="Cannot complete assessment: No answers provided.")
    
    try:
        # 2. Calculate actual total score based on answers (passing None for db)
        calculated_total_score = calculate_total_score(items_data, None)
        
        # 3. Store final record in SessionStore
        session_store.complete_assessment(
            session_id=session_id,
            total_score=calculated_total_score,
            cluster_id=full_session["session"]["cluster_id"]
        )
        
    except Exception as e:
        print(f"Error completing assessment: {e}")
        raise HTTPException(status_code=500, detail=f"Failed to complete assessment: {str(e)}")

    return {"message": "Assessment completed and stored in-memory", "session_id": session_id}

@router.delete("/{session_id}")
def delete_session(session_id: int):
    """
    Manually wipe an assessment session from memory.
    """
    session_store.delete_session(session_id)
    return {"message": f"Session {session_id} wiped successfully"}

