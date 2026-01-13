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

    questions = {1: {'Dimension': 'Strategy & Business Vision',
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
                }

    print(Gui_Questions.model_validate(questions))

    responses = {1: {'Response': {3:1}
                    },
                 2: {'Response': {1:1, 4:1}
                    }
                }
    
    print(Gui_Response.model_validate(responses))

    # use this file by includiung it:
    # from app.schema import Gui_Questions, Gui_Response
    