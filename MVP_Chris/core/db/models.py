from sqlalchemy import Column, Integer, String, Boolean, Float, ForeignKey, Text, BigInteger
from sqlalchemy.dialects.postgresql import ARRAY
from sqlalchemy.orm import relationship
from core.db.database import Base

class Dimension(Base):
    __tablename__ = "dimensions"
    
    dimension_id = Column(Integer, primary_key=True)
    dimension_name = Column(String)
    dimension_weight = Column(Float)
    
    questions = relationship("Question", back_populates="dimension")

class Question(Base):
    __tablename__ = "questions"
    
    question_id = Column(Integer, primary_key=True)
    dimension_id = Column(Integer, ForeignKey("dimensions.dimension_id"))
    header = Column(String)
    question_text = Column(String)
    type = Column(String) # 'Choice', 'Slider', etc.
    weight = Column(Float)
    optional = Column(Boolean, default=False)
    
    dimension = relationship("Dimension", back_populates="questions")
    answers = relationship("Answer", back_populates="question")

class Answer(Base):
    __tablename__ = "answers"
    
    answer_id = Column(Integer, primary_key=True)
    question_id = Column(Integer, ForeignKey("questions.question_id"))
    answer_text = Column(String)
    answer_level = Column(Integer)
    answer_weight = Column(Float)
    
    question = relationship("Question", back_populates="answers")

class ClusterProfile(Base):
    __tablename__ = "cluster_profiles"
    
    cluster_id = Column(BigInteger, primary_key=True)
    cluster_name = Column(String)
    description = Column(String)
    score_min = Column(Float)
    score_max = Column(Float)

class Company(Base):
    __tablename__ = "companies"
    
    company_id = Column(Integer, primary_key=True, autoincrement=True)
    company_name = Column(String)
    industry = Column(String)
    website = Column(String)
    number_of_employees = Column(String)
    city = Column(String)
    email = Column(Text, nullable=True)

class Response(Base):
    __tablename__ = "responses"
    
    response_id = Column(Integer, primary_key=True, autoincrement=True)
    company_id = Column(Integer, ForeignKey("companies.company_id"))
    total_score = Column(String) # Schema says varchar
    created_at = Column(Text) # or Date/Time
    cluster_id = Column(BigInteger, ForeignKey("cluster_profiles.cluster_id"))
    ab_group = Column(String, default="B") # A=Control (Rules), B=Test (ML)
    
    # response_items relationship if needed
    items = relationship("ResponseItem", back_populates="response")
    company = relationship("Company")
    cluster = relationship("ClusterProfile")

class ResponseItem(Base):
    __tablename__ = "response_items"
    
    item_id = Column(Integer, primary_key=True)
    response_id = Column(Integer, ForeignKey("responses.response_id"))
    question_id = Column(Integer, ForeignKey("questions.question_id"))
    answers = Column(ARRAY(Integer))
    
    response = relationship("Response", back_populates="items")
