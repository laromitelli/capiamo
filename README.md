# Capiamo APP
## Summary

Always know where the situa is

## Environment

* DB and db plugins
  
  PostgreSQL
  
  PostGIS - postgres plugin to easily query gps location
  
* Backend API
  
  FastAPI (Python)

* Frontend
  
  Flutter (Dart)

* Production (and dev) Environment

  Private server (temporary) 93.55.240.107 - rasbpberry/linux like environment
  
## 1. DB

PostgreSQL v. 17.5

PostGIS v. 3.6.0

#### Tables

    CREATE TABLE users (
      id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      username TEXT NOT NULL,
      provider TEXT NOT NULL,
      provider_token TEXT NOT NULL,
      created_at TIMESTAMP DEFAULT now()
    );

    CREATE TABLE messages (
      id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
      user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
      message TEXT,
      location GEOGRAPHY(Point, 4326),
      created_at TIMESTAMP DEFAULT now(),
      expires_at TIMESTAMP DEFAULT (now() + interval '4 hours')
    );

#### Insert example

    INSERT INTO messages (message, location)
      VALUES (
        '1',
        'Situa',
        ST_SetSRID(ST_MakePoint(12.4924, 41.8902), 4326)
      );
  	
#### Select example

    SELECT id, message, created_at
    FROM messages
    WHERE ST_DWithin(
      location,
      ST_SetSRID(ST_MakePoint(:lon, :lat), 4326)::geography,
      5000
    );

#### Open points

Comments

Data Retention (crontab, etc..)

  
## 2. Backend

Python 3.12

fastapi 0.102.0

Other dependencies (uvicorn?, sqlalchemy?,..)

#### Endpoints

##### 1. Message save
  

    POST /messages
  
      {
        "user": "",
        "message": "",
        "lon": "",
        "lan": ""
      }
    
  Response:

  200/400/500



##### 2. Messages retrieve
  

GET /messages?lat=X&lon=Y[&radius=5000]
  

  Response
  
  200/404/400/500

    body:
  

      [
        {
          "lan": "",
          "lon": "",
          "message": ""
        },
        ...
      ]


#### Open points

User Create/login -> Better to use an auth provider (IG, google, etc..)

Comments Endpoint

Rate limiting (Spam prevention)

Input check (XSS protection)

  
## 3. Frontend App (work in progress)

Flutter (last stable version)

#### App Sections

##### 1. Login
##### 2. Home - Map - Markers around me (clickable) - Add button
##### 3. Form to add new Event  
##### 4. Admin page (hide profile picture - Update username)

<img width="1536" height="1024" alt="d7f83dde-28f1-42ba-9098-c39010bf1e86" src="https://github.com/user-attachments/assets/caf979a3-4c02-4293-9c89-efe866d4baa5" />

#### Open points

Anonymous login vs in-app login vs external provider login/auth (gmail, instagram,..). Affects backend.

????
