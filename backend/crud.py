from sqlalchemy.orm import Session
from sqlalchemy import text
from geoalchemy2.functions import ST_Distance, ST_GeogFromText
import models
from datetime import datetime
import uuid
from sqlalchemy.dialects.postgresql import insert
from geoalchemy2.shape import to_shape

from sqlalchemy import func


#def get_users(db: Session):
#    return db.query(models.User).all()
 

def get_user_by_user_id(db: Session, id: str):
    return db.query(models.User).filter(models.User.id == id).first()
   
def upsert_user(db: Session, user_id: str, name: str, profile_uri: str, hide_profile_picture: bool):
    stmt = insert(models.User).values(
        user_id=user_id,
        displayed_name=name,
        profile_picture_uri=profile_uri,
        hide_profile_picture=hide_profile_picture
    ).on_conflict_do_update(
        index_elements=[models.User.user_id],
        set_={
            "displayed_name": name,
            "profile_picture_uri": profile_uri,
            "hide_profile_picture": hide_profile_picture,
            "updated_at": datetime.now(),
        }
    )
    db.execute(stmt)
    db.commit()
    
    return db.query(models.User).filter(models.User.user_id == user_id).first()


def message_to_out(message):
    lat, lon = (None, None)
    if message.location:
        point = to_shape(message.location)
        lon, lat = point.x, point.y
    return {
        "id": message.id,
        "user_id": message.user_id,
        "message": message.message,
        "lat": lat,
        "lon": lon,
        "created_at": message.created_at,
        "expires_at": message.expires_at
    }


def create_message(db: Session, user_id: uuid.UUID, message: str, latitude: float = None, longitude: float = None):
    """
    Create a message optionally with a location.
    """
    loc_wkt = None
    if latitude is not None and longitude is not None:
        # PostGIS WKT format: 'SRID=4326;POINT(lon lat)'
        loc_wkt = f'SRID=4326;POINT({longitude} {latitude})'

    db_message = models.Message(
        user_id=user_id,
        message=message,
        location=loc_wkt
    )
    db.add(db_message)
    db.commit()
    db.refresh(db_message)
    return message_to_out(db_message)

def get_messages_near(db: Session, latitude: float, longitude: float, radius_meters: float = 500):
    """
    Get messages within `radius_meters` of a given point.
    """
    point_wkt = f'SRID=4326;POINT({longitude} {latitude})'

    query = (
        db.query(models.Message)
        .filter(models.Message.expires_at > func.now())
        .filter(
            ST_Distance(models.Message.location, ST_GeogFromText(point_wkt)) <= radius_meters
        )
        .order_by(ST_Distance(models.Message.location, ST_GeogFromText(point_wkt)))
    )
    messages = query.all()
    return [message_to_out(m) for m in messages]


