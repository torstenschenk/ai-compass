import json
import os
import time
from typing import Dict, Optional

# File to store completed assessments
DATA_DIR = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), "data")
ASSESSMENTS_FILE = os.path.join(DATA_DIR, "assessments.json")

def _load_db() -> Dict[str, dict]:
    if not os.path.exists(ASSESSMENTS_FILE):
        return {}
    try:
        with open(ASSESSMENTS_FILE, "r") as f:
            return json.load(f)
    except Exception as e:
        print(f"Error loading assessments DB: {e}")
        return {}

def _save_db(data: Dict[str, dict]):
    try:
        os.makedirs(DATA_DIR, exist_ok=True)
        with open(ASSESSMENTS_FILE, "w") as f:
            json.dump(data, f, indent=4)
    except Exception as e:
        print(f"Error saving assessments DB: {e}")

def save_assessment(response_id: int, session_data: dict, total_score: float, cluster_id: int):
    """
    Persist a completed assessment to the JSON store.
    """
    db = _load_db()
    
    # Structure the record for storage
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
    
    db[str(response_id)] = record
    _save_db(db)

def get_assessment(response_id: int) -> Optional[dict]:
    """
    Retrieve an assessment by ID.
    """
    db = _load_db()
    return db.get(str(response_id))
