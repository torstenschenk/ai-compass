from typing import Dict, List, Optional
from schemas.company import CompanyCreate
from schemas.response import ResponseCreate
import logging
from datetime import datetime
import time

logger = logging.getLogger(__name__)

class SessionStore:
    _instance = None
    
    def __new__(cls):
        if cls._instance is None:
            cls._instance = super(SessionStore, cls).__new__(cls)
            cls._instance.companies: Dict[int, dict] = {}
            cls._instance.responses: Dict[int, dict] = {}
            cls._instance.response_values: Dict[int, List[dict]] = {} # response_id -> list of answers
            cls._instance.completed_assessments: Dict[str, dict] = {} # response_id -> full record
            
            # Initialize counters
            cls._instance.company_counter = 1000
            cls._instance.response_counter = 1000
            
        return cls._instance

    def create_company(self, company: CompanyCreate) -> dict:
        self.company_counter += 1
        new_company = company.model_dump()
        new_company["company_id"] = self.company_counter
        self.companies[self.company_counter] = new_company
        return new_company

    def get_company(self, company_id: int) -> Optional[dict]:
        return self.companies.get(company_id)

    def create_response(self, response: ResponseCreate) -> dict:
        self.response_counter += 1
        # Create a dict representation
        new_response = {
            "response_id": self.response_counter,
            "company_id": response.company_id,
            "total_score": None,
            "created_at": datetime.utcnow(), 
            "cluster_id": None
        }
        self.responses[self.response_counter] = new_response
        return new_response

    def get_response(self, response_id: int) -> Optional[dict]:
        return self.responses.get(response_id)
        
    def save_answer(self, response_id: int, question_id: int, answer_ids: List[int]):
        if response_id not in self.response_values:
            self.response_values[response_id] = []
        
        # Remove existing answer for this question
        self.response_values[response_id] = [
            x for x in self.response_values[response_id] 
            if x["question_id"] != question_id
        ]
        
        # Add new answer
        new_item = {
            "item_id": 0, # Dummy ID
            "response_id": response_id,
            "question_id": question_id,
            "answers": answer_ids
        }
        self.response_values[response_id].append(new_item)
        return new_item

    def get_response_items(self, response_id: int) -> List[dict]:
        return self.response_values.get(response_id, [])

    def get_full_session(self, response_id: int) -> Optional[dict]:
        response = self.get_response(response_id)
        if not response:
            return None
        
        company = self.get_company(response["company_id"])
        items = self.get_response_items(response_id)
        
        return {
            "company": company,
            "response": response,
            "items": items
        }

    def complete_assessment(self, response_id: int, total_score: float, cluster_id: int):
        """
        Store the final assessment record in memory.
        """
        session_data = self.get_full_session(response_id)
        if not session_data:
            return
            
        record = {
            "response_id": response_id,
            "company": session_data.get("company"),
            "response_meta": session_data.get("response"),
            "items": session_data.get("items"),
            "computed_results": {
                 "total_score": total_score,
                 "cluster_id": cluster_id,
                 "completed_at": time.time()
            }
        }
        
        self.completed_assessments[str(response_id)] = record

    def get_assessment(self, response_id: int) -> Optional[dict]:
        """
        Retrieve a completed assessment by ID.
        """
        return self.completed_assessments.get(str(response_id))

session_store = SessionStore()

