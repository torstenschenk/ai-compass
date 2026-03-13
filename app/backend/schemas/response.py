from pydantic import BaseModel
from typing import List, Optional
from datetime import datetime

class ResponseItemBase(BaseModel):
    question_id: int
    answer_ids: List[int]

class SessionCreate(BaseModel):
    company_name: str
    industry: str
    website: Optional[str] = None
    number_of_employees: str
    city: str
    email: str

class ResponseUpdate(BaseModel):
    question_id: int
    answer_ids: List[int]

class SessionDetail(BaseModel):
    session_id: int
    company_name: str
    
    class Config:
        from_attributes = True
