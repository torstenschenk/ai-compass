from typing import Dict, List, Optional
from schemas.response import SessionCreate
import logging
import time

logger = logging.getLogger(__name__)

class SessionStore:
    _instance = None
    
    def __new__(cls):
        if cls._instance is None:
            cls._instance = super(SessionStore, cls).__new__(cls)
            cls._instance.sessions: Dict[int, dict] = {} # session_id -> session data
            cls._instance.response_values: Dict[int, List[dict]] = {} # session_id -> list of answers
            cls._instance.completed_assessments: Dict[int, dict] = {} # session_id -> full record
            
            # Initialize counters
            cls._instance.session_counter = 1000
            
        return cls._instance

    def create_session(self, session_data: SessionCreate) -> dict:
        self.session_counter += 1
        new_session = session_data.model_dump()
        new_session["session_id"] = self.session_counter
        new_session["total_score"] = None
        new_session["cluster_id"] = None
        new_session["created_at"] = time.time()
        
        self.sessions[self.session_counter] = new_session
        
        # Schedule the session to be automatically deleted after 1 hour (3600 seconds)
        import threading
        timer = threading.Timer(3600, self.delete_session, args=[self.session_counter])
        timer.daemon = True
        timer.start()
        
        return new_session

    def get_session(self, session_id: int) -> Optional[dict]:
        return self.sessions.get(session_id)
        
    def save_answer(self, session_id: int, question_id: int, answer_ids: List[int]):
        if session_id not in self.response_values:
            self.response_values[session_id] = []
        
        # Remove existing answer for this question
        self.response_values[session_id] = [
            x for x in self.response_values[session_id] 
            if x["question_id"] != question_id
        ]
        
        # Add new answer
        new_item = {
            "item_id": 0, # Dummy ID
            "session_id": session_id,
            "question_id": question_id,
            "answers": answer_ids
        }
        self.response_values[session_id].append(new_item)
        return new_item

    def get_response_items(self, session_id: int) -> List[dict]:
        return self.response_values.get(session_id, [])

    def get_full_session(self, session_id: int) -> Optional[dict]:
        session = self.get_session(session_id)
        if not session:
            return None
        
        items = self.get_response_items(session_id)
        
        return {
            "session": session,
            "items": items
        }

    def complete_assessment(self, session_id: int, total_score: float, cluster_id: int):
        """
        Store the final assessment record in memory.
        """
        full_session = self.get_full_session(session_id)
        if not full_session:
            return
            
        record = {
            "session_id": session_id,
            "session_data": full_session.get("session"),
            "items": full_session.get("items"),
            "computed_results": {
                 "total_score": total_score,
                 "cluster_id": cluster_id,
                 "completed_at": time.time()
            }
        }
        
        self.completed_assessments[session_id] = record
        
        # Also update the session entry for SessionDetail schema
        if session_id in self.sessions:
            self.sessions[session_id]["total_score"] = str(total_score)
            self.sessions[session_id]["cluster_id"] = cluster_id

    def get_assessment(self, session_id: int) -> Optional[dict]:
        """
        Retrieve a completed assessment by ID.
        """
        return self.completed_assessments.get(session_id)

    def delete_session(self, session_id: int):
        """
        Wipe all data associated with a session ID.
        """
        instance = SessionStore._instance
        if session_id in instance.sessions:
            del instance.sessions[session_id]
        if session_id in instance.response_values:
            del instance.response_values[session_id]
        if session_id in instance.completed_assessments:
            del instance.completed_assessments[session_id]
        logger.info(f"Session {session_id} wiped from memory by automatic cleanup.")

session_store = SessionStore()

