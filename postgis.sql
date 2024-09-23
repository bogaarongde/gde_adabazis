CREATE EXTENSION postgis;

CREATE TABLE if not exists places (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255),
    location GEOGRAPHY(Point)
);

INSERT INTO places (name, location)
VALUES
    ('Place A', ST_MakePoint(-0.1257, 51.5085)), -- London koordinátái
    ('Place B', ST_MakePoint(2.3522, 48.8566));  -- Párizs koordinátái

SELECT
    p1.name as place1,
    p2.name as place2,
    ST_Distance(p1.location, p2.location) as distance_meters
FROM
    places p1,
    places p2
WHERE
    p1.name = 'Place A' AND p2.name = 'Place B';
