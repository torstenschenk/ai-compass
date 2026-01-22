from pydantic import BaseModel
from typing import List, Optional
from datetime import datetime

class ResponseItemBase(BaseModel):
    question_id: int
    answer_ids: List[int]

class ResponseCreate(BaseModel):
    company_id: int

class ResponseUpdate(BaseModel):
    question_id: int
    answer_ids: List[int]

class ResponseDetail(BaseModel):
    response_id: int
    company_id: int
    total_score: Optional[str] = None
    created_at: datetime
    cluster_id: Optional[int] = None
    
    class Config:
        from_attributes = True
