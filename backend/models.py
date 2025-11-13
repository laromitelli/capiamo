from sqlalchemy import Column, Text, TIMESTAMP, ForeignKey, Integer, String, Boolean, DateTime
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.sql import func
from geoalchemy2 import Geography
from sqlalchemy.orm import declarative_base

import uuid

Base = declarative_base()

class User(Base):
    __tablename__ = "users"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(String, nullable=False, unique=True)    
    displayed_name = Column(String, nullable=False)
    profile_picture_uri = Column(String, nullable=False)
    hide_profile_picture = Column(Boolean, nullable=False)
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), server_default=func.now())

class Message(Base):
    __tablename__ = "messages"

    id = Column(
        UUID(as_uuid=True), 
        primary_key=True, 
        default=uuid.uuid4,
        unique=True,
        nullable=False
    )
    user_id = Column(
        UUID(as_uuid=True), 
        ForeignKey("users.id", ondelete="CASCADE"), 
        nullable=False
    )
    message = Column(Text, nullable=True)
    location = Column(Geography(geometry_type="POINT", srid=4326), nullable=True)
    created_at = Column(TIMESTAMP(timezone=True), server_default=func.now(), nullable=False)
    expires_at = Column(
        TIMESTAMP(timezone=True), 
        server_default=func.now() + func.interval('4 hours'), 
        nullable=False
    )