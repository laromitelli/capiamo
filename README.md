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
      user_id TEXT NOT NULL,
      displayed_name TEXT NOT NULL,
      profile_picture_uri TEXT NOT NULL,
      hide_profile_picture BOOLEAN,
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


##### 1. User save
  
    PUT /users
  
      {
        "user_id": "",
        "displayed_name": "",
        "profile_picture_uri": ""
      }
    
  Response:

  200/400/500
  
##### 2. Message save
  

    POST /messages
  
      {
        "user": "",
        "message": "",
        "lon": "",
        "lan": ""
      }
    
  Response:

  200/400/500



##### 3. Messages retrieve
  

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

Flutter (last stable version). Needs an internal APP DB (sqlite or see what s available for flutter)

#### App Sections

##### 1. Login
##### 2. Home - Map - Markers around me (clickable) - Add button
##### 3. Form to add new Event  
##### 4. Admin page (hide profile picture - Update username)

<img width="1536" height="1024" alt="d7f83dde-28f1-42ba-9098-c39010bf1e86" src="https://github.com/user-attachments/assets/caf979a3-4c02-4293-9c89-efe866d4baa5" />

#### 1. Login

Retrieve app status with user info from APP DB.

If logged, redirect to Home (2).

If not logged:
  1. show IG login button (let the user login)
  2. once logged, call the Backend HTTP Endpoint that athorizes the user
  3. save the user session in the APP DB  (to avoid future login)

#### 2. Home

1. Call backend endpoints to retrieve "situa" around you (5miles radius)
2. Render Map (using flutter integrated google maps) and add marker for each "situa" found
3. Render a plus button (+)
4. Render a toolbar with a user icon
5. Schedule a job that retrieves/refresh "situas" each 2(?) minutes

At this point users can perform 3 actions:

1. click (+) button. Open a popup form to let the user write a situa (see 3).
2. click user icon from toolbar. Open admin page (see 4)
3. click on a map marker (situa). Open a pop up with the situa message.

#### 3. Form or popup to add a new Event (situa)

Basic form with a Send button.

When clicked, a backend endpoint is called to store the new Event.

Render created event.

#### 4. Admin page

Basic form that allows user to edit his name and to hide the profile picture.

When save is clicked, a backend endpoint is called to store the user info. 

Update local session and DB to save new info.

#### Open points

Busy area?
