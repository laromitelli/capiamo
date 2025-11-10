# Capiamo APP
## Summary

Always know where the situa is

## Environment

* Frontend
  
  Flutter (Dart)

* Backend API
  
  FastAPI (Python)

* DB and db plugins
  
  PostgreSQL 
  PostGIS - postgres plugin to easily query gps location

* Production Environment

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
