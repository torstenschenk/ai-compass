from fastapi import APIRouter, HTTPException
from schemas import questionnaire as schemas
from services.questionnaire_service import get_all_questions

router = APIRouter()

@router.get("/", response_model=schemas.Questionnaire)
def get_questionnaire():
    """
    Fetch the full questionnaire with all questions and answers.
    Loaded from JSON files via questionnaire_service.
    """
    questions = get_all_questions()
    
    if not questions:
         raise HTTPException(status_code=500, detail="Failed to load questionnaire data")
         
    return {"questions": questions}
