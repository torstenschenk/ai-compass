from fastapi import APIRouter
from schemas import company as schemas
from services.session_store import session_store

router = APIRouter()

@router.post("/", response_model=schemas.CompanyResponse)
def create_company(company: schemas.CompanyCreate):
    """
    Create a new company profile.
    """
    new_company = session_store.create_company(company)
    return new_company
