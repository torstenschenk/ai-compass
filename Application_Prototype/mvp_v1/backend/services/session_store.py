from typing import Dict, List, Optional
from schemas.company import CompanyCreate
from schemas.response import ResponseCreate
# from database import SessionLocal # REMOVED
# from models.company import Company # REMOVED
# from models.response import Response # REMOVED
# from sqlalchemy import func # REMOVED
import logging
from datetime import datetime
from services.persistence_service import _load_db

logger = logging.getLogger(__name__)

class SessionStore:
    _instance = None
    
    def __new__(cls):
        if cls._instance is None:
            cls._instance = super(SessionStore, cls).__new__(cls)
            cls._instance.companies: Dict[int, dict] = {}
            cls._instance.responses: Dict[int, dict] = {}
            cls._instance.response_values: Dict[int, List[dict]] = {} # response_id -> list of answers
            
            # Initialize counters from FILE persistence
            cls._instance._init_counters()
            
        return cls._instance

    def _init_counters(self):
        try:
            db_data = _load_db()
            if db_data:
                # assessments.json keys are response_ids
                max_r = max([int(k) for k in db_data.keys()]) if db_data else 0
                # companies are embedded, find max company_id
                max_c = 0
                for r in db_data.values():
                    if "company" in r and "company_id" in r["company"]:
                        c_id = r["company"]["company_id"]
                        if c_id > max_c:
                            max_c = c_id
                            
                self.company_counter = max(1000, max_c)
                self.response_counter = max(1000, max_r)
                logger.info(f"Initialized SessionStore from JSON - Company: {self.company_counter}, Response: {self.response_counter}")
            else:
                self.company_counter = 1000
                self.response_counter = 1000
        except Exception as e:
            logger.error(f"Error initializing session counters: {e}")
            self.company_counter = 1000
            self.response_counter = 1000

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

session_store = SessionStore()
