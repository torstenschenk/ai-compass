import json
import os
from typing import List, Dict, Optional

# Global cache
_QUESTIONS: List[dict] = []
_DIMENSIONS: List[dict] = []
_CLUSTERS: List[dict] = []
_QUESTION_MAP: Dict[int, dict] = {}

def _load_json(filename: str) -> List[dict]:
    """Helper to load a JSON file from the data directory."""
    # current_dir is backend/services
    base_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__))) # backend
    data_path = os.path.join(base_dir, "data", filename)
    
    if not os.path.exists(data_path):
        print(f"Error: Data file not found at {data_path}")
        return []
        
    try:
        with open(data_path, "r") as f:
            return json.load(f)
    except Exception as e:
        print(f"Error loading {filename}: {e}")
        return []

def load_data(force_reload: bool = False):
    """Loads all static data into memory."""
    global _QUESTIONS, _DIMENSIONS, _CLUSTERS, _QUESTION_MAP
    
    if _QUESTIONS and not force_reload:
        return

    _QUESTIONS = _load_json("questions.json")
    _DIMENSIONS = _load_json("dimensions.json")
    _CLUSTERS = _load_json("clusters.json")
    
    _QUESTION_MAP = {q["question_id"]: q for q in _QUESTIONS}

def get_all_questions() -> List[dict]:
    load_data()
    return _QUESTIONS

def get_question_map() -> Dict[int, dict]:
    load_data()
    return _QUESTION_MAP

def get_all_dimensions() -> List[dict]:
    load_data()
    return _DIMENSIONS

def get_all_clusters() -> List[dict]:
    load_data()
    return _CLUSTERS

def get_cluster_by_id(cluster_id: int) -> Optional[dict]:
    load_data()
    for c in _CLUSTERS:
        if c["cluster_id"] == cluster_id:
            return c
    return None
