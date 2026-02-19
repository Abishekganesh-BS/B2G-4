from sqlalchemy import Column, Integer, String, Float, DateTime, ForeignKey, Text, Boolean
from sqlalchemy.orm import relationship
from pgvector.sqlalchemy import Vector
from app.db.base_class import Base
from datetime import datetime

class User(Base):
    __tablename__ = "users"
    id = Column(Integer, primary_key=True, index=True)
    email = Column(String, unique=True, index=True)
    full_name = Column(String, index=True)
    hashed_password = Column(String)
    # Onboarding fields
    age = Column(Integer, nullable=True)
    pre_pregnancy_weight = Column(Float, nullable=True)
    lmp_date = Column(DateTime, nullable=True)
    conditions = Column(Text, nullable=True)  # JSON string e.g. '["hypertension"]'
    is_onboarded = Column(Boolean, default=False)
    metrics = relationship("Metric", back_populates="owner")
    sessions = relationship("TeleSession", back_populates="owner")

class Metric(Base):
    __tablename__ = "metrics"
    id = Column(Integer, primary_key=True, index=True)
    metric_type = Column(String, index=True) # glucose, weight, bp, etc.
    value = Column(Float)
    unit = Column(String)
    timestamp = Column(DateTime, default=datetime.utcnow)
    owner_id = Column(Integer, ForeignKey("users.id"))
    owner = relationship("User", back_populates="metrics")

class TeleSession(Base):
    __tablename__ = "tele_sessions"
    id = Column(Integer, primary_key=True, index=True)
    title = Column(String)
    scheduled_at = Column(DateTime)
    notes = Column(Text, nullable=True)
    created_at = Column(DateTime, default=datetime.utcnow)
    owner_id = Column(Integer, ForeignKey("users.id"))
    owner = relationship("User", back_populates="sessions")

class ReactedDocument(Base):
    __tablename__ = "documents"
    id = Column(Integer, primary_key=True, index=True)
    content = Column(Text)
    embedding = Column(Vector(1536))
    metadata_json = Column(Text)
