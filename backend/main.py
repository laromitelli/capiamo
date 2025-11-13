from fastapi import FastAPI, Depends, HTTPException, Query
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker, Session
import models, crud
import os
from pydantic import BaseModel

# Database setup

DATABASE_URL = os.getenv("DATABASE_URL")
engine = create_engine(DATABASE_URL)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

# FastAPI setup
app = FastAPI()

# Endpoint Utils

class UserObj(BaseModel):
    user_id: str
    name: str
    profile_uri: str
    hide_pic: bool

class MsgObj(BaseModel):
    user_id: str
    message: str
    lat: float
    lon: float

# Endpoints

@app.get("/status")
def read_root():
    return {"message": "Capiamo Endpoints up and running."}

#@app.get("/users")
#def read_users(db: Session = Depends(get_db)):
#    return crud.get_users(db)

@app.post("/users")
def create_user(user: UserObj, db: Session = Depends(get_db)):
    return crud.upsert_user(db, user.user_id, user.name, user.profile_uri, user.hide_pic)

@app.get("/users/{id}")
def read_user(id: str, db: Session = Depends(get_db)):
    user = crud.get_user_by_user_id(db, id)
    if not user:
        raise HTTPException(status_code=404)
    return user

@app.post("/messages")
def add_message(message: MsgObj, db: Session = Depends(get_db)):
    return crud.create_message(db, user_id=message.user_id, message=message.message, latitude=message.lat, longitude=message.lon)

@app.get("/messages/near")
def nearby_messages(
    lat: float = Query(..., description="Latitude of reference point"),
    lon: float = Query(..., description="Longitude of reference point"),
    radius: float = Query(5000, description="Radius in meters"), db: Session = Depends(get_db)):
    return crud.get_messages_near(db, latitude=lat, longitude=lon, radius_meters=radius)