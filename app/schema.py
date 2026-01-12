from pydantic import BaseModel, StrictInt, RootModel
from typing import Union, Literal, Dict

# DB loaded question data: send to frontend
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
    Response: Dict[int, int]

class Gui_Response(RootModel):
    root: Dict[int, Response_Data]


if __name__ == '__main__':

    questions = {0: {'Dimension': 'Strategy & Business Vision',
                     'Header': 'Leadership Alignment',
                     'Question': 'How is AI prioritized in management meetings?',
                     'Type': 'Statement',
                     'Optional': 'False', 
                     'Answers': {0:'Not a topic / Ignored', 1:'Rare mention in meetings', 2:'Occasional discussion', 3:'Regular agenda item', 4:'Core strategic pillar'}
                    },
                 1: {'Dimension': 'Governance & Compliance',
                     'Header': 'Guidelines',
                     'Question': 'Do you have an internal "AI Code of Conduct"?',
                     'Type': 'Choice',
                     'Optional': 'False',
                     'Answers': {0:'No plan', 1:'Theoretical idea', 2:'Case-by-case choice', 3:'Defined scaling path', 4:'Automated deployment'}
                    }
                }

    print(Gui_Questions.model_validate(questions))

    responses = {0: {'Response': {3:1}
                    },
                 1: {'Response': {0:1, 7:1}
                    }
                }
    
    print(Gui_Response.model_validate(responses))

    # use this file by includiung it:
    # from app.schema import Gui_Questions, Gui_Response
    