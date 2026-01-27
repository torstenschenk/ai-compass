from pydantic import BaseModel
from typing import List, Optional, Dict, Any

class CompanyCreate(BaseModel):
    company_name: str
    industry: str
    website: Optional[str] = None
    number_of_employees: str
    city: Optional[str] = None
    email: Optional[str] = None

class ResponseCreate(BaseModel):
    company: CompanyCreate

class ResponseItemCreate(BaseModel):
    question_id: int
    answer_ids: List[int]

class ResponseItemsBatch(BaseModel):
    items: List[ResponseItemCreate]

class TokenResponse(BaseModel):
    response_id: int
    access_token: str

class DimensionScore(BaseModel):
    dimension_id: int
    dimension_name: str
    score: float
    max_score: float
    industry_score: Optional[float] = None

class ClusterProfileRead(BaseModel):
    cluster_id: int
    name: str
    description: str

class RoadmapItem(BaseModel):
    theme: str
    source: str
    impact: float
    dimension: str
    explanation: str

class StrategicFinding(BaseModel):
    type: str  # "Anomaly" or "Weakness"
    title: str
    score: float
    context: str
    dimension_name: Optional[str] = None
    tactical_theme: Optional[str] = None

class StrategicGapAnalysis(BaseModel):
    executive_briefing: str
    detailed_findings: List[StrategicFinding]

class ResponseRead(BaseModel):
    id: int
    company_name: str
    industry: Optional[str] = "Unknown"
    overall_score: float
    dimension_scores: List[DimensionScore]
    cluster: Optional[ClusterProfileRead] = None
    roadmap: Optional[Dict[str, List[RoadmapItem]]] = None
    strategic_gap_analysis: Optional[StrategicGapAnalysis] = None
    completed_at: Optional[str] = None
