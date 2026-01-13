# Use this file by includiung it:
# from app.schema import Gui_Questions, Gui_Response, Gui_Report

from pydantic import BaseModel, StrictInt, RootModel
from typing import Union, Literal, Dict


# DB loaded questionaire data: send to frontend
class Question_Data(BaseModel):
    Dimension: str
    Header: str
    Question: str
    Type: str
    Optional: str
    Answers: Dict[int, str]

class Gui_Questions(RootModel):
    root: Dict[int, Question_Data]

# Frontend user response data: received from backend
class Response_Data(BaseModel):
    Company_url: str
    Email: str
    Response: Dict[int, int]

class Gui_Response(RootModel):
    root: Dict[int, Response_Data]

# Frontend queried: report data
class Report_Data(BaseModel):
    Final_score: float
    Category_scores: Dict[str, float]
    Cluster: str
    Cluster_score: float
    
class Gui_Report(RootModel):
    root: Report_Data


if __name__ == '__main__':

    # Examples: (numbering convention: human readable)
    questioniare = {1: {'Dimension': 'Strategy & Business Vision',
                     'Header': 'Leadership Alignment',
                     'Question': 'How is AI prioritized in management meetings?',
                     'Type': 'Statement',
                     'Optional': 'False', 
                     'Answers': {1:'Not a topic / Ignored', 2:'Rare mention in meetings', 3:'Occasional discussion', 4:'Regular agenda item', 5:'Core strategic pillar'}
                    },
                 2: {'Dimension': 'Governance & Compliance',
                     'Header': 'Guidelines',
                     'Question': 'Do you have an internal "AI Code of Conduct"?',
                     'Type': 'Choice',
                     'Optional': 'False',
                     'Answers': {1:'No plan', 2:'Theoretical idea', 3:'Case-by-case choice', 4:'Defined scaling path', 5:'Automated deployment'}
                    }
                 # ...
                }

    print(Gui_Questions.model_validate(questioniare))

    response = {1: {
                    'Company_url': 'https://www.accenture.com/de-de',
                    'Email': 'it@accenture.com',
                    'Response': {3:1}
                    },
                 2: {
                    'Company_url': 'https://www.cito.de/en/GB/',
                    'Email': 'ceo@cito.de',
                    'Response': {1:1, 4:1}
                    }
                 # ...
                }
    
    print(Gui_Response.model_validate(response))

    report = {
                'Final_score': 0.173,
                'Category_scores': {'Strategy & Business Vision': 0.2,
                                    'People & Culture': 0.1,
                                    'Data Readiness & Literacy': 0.03,
                                    'Use Cases & Business Value': 0.56,
                                    'Processes & Scaling': 0.19,
                                    'Governance & Compliance': 0.11,
                                    'Tech Infrastructure': 0.07},
                'Cluster': 'The Traditionalist',
                'Cluster_score': 0.93
            }

    print(Gui_Report.model_validate(report))
    # format json output
    print(Gui_Report.model_validate(report).model_dump_json(indent=2))