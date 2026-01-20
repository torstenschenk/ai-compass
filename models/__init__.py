# This file makes the models directory a Python package
from .ai_compass_api import analyze_company, AICompassAPI

__all__ = ['analyze_company', 'AICompassAPI']
