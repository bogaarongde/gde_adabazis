docker run --name pg2 -e POSTGRES_PASSWORD=postgres -p 5488:5432 --cpus=".2" --memory="256m" -d postgres:latest



CREATE TABLE termekek (
    termek_id SERIAL PRIMARY KEY,
    termek_nev VARCHAR(255),
    kategoria VARCHAR(255),
    ar DECIMAL(10, 2),
    keszlet_mennyiseg INT
);

CREATE TABLE vasarlok (
    vasarlo_id SERIAL PRIMARY KEY,
    vasarlo_nev VARCHAR(255),
    varos VARCHAR(255),
    regisztracio_datum DATE
);

CREATE TABLE rendelesek (
    rendeles_id SERIAL PRIMARY KEY,
    vasarlo_id INT REFERENCES vasarlok(vasarlo_id),
    rendeles_datum DATE
);

CREATE TABLE rendeles_tetelek (
    rendeles_tetel_id SERIAL PRIMARY KEY,
    rendeles_id INT REFERENCES rendelesek(rendeles_id),
    termek_id INT REFERENCES termekek(termek_id),
    mennyiseg INT
);


-- Termékek feltöltése (például 10 000 különböző termék)
INSERT INTO termekek (termek_nev, kategoria, ar, keszlet_mennyiseg)
SELECT
    'Termek ' || i,
    CASE WHEN i % 2 = 0 THEN 'Zöldség' ELSE 'Gyümölcs' END,
    RANDOM() * 100 + 50,
    (RANDOM() * 500)::INT
FROM generate_series(1, 10000) i;

-- Vásárlók feltöltése
INSERT INTO vasarlok (vasarlo_nev, varos, regisztracio_datum)
SELECT
    'Vasarlo ' || i,
    CASE WHEN i % 3 = 0 THEN 'Budapest' WHEN i % 3 = 1 THEN 'Debrecen' ELSE 'Szeged' END,
    NOW() - (INTERVAL '1 day' * (RANDOM() * 1000)::INT)
FROM generate_series(1, 50000) i;

-- Rendelések feltöltése
INSERT INTO rendelesek (vasarlo_id, rendeles_datum)
SELECT (RANDOM() * 49999+1)::INT, NOW() - (INTERVAL '1 day' * (RANDOM() * 100)::INT)
FROM generate_series(1, 100000);

-- Rendelés tételek feltöltése
INSERT INTO rendeles_tetelek (rendeles_id, termek_id, mennyiseg)
SELECT (RANDOM() * 99999+1)::INT, (RANDOM() * 9999+1)::INT, (RANDOM() * 10 + 1)::INT
FROM generate_series(1, 1000000);



EXPLAIN ANALYZE
SELECT v.vasarlo_nev, r.rendeles_datum, t.termek_nev, rt.mennyiseg, t.ar
FROM vasarlok v
JOIN rendelesek r ON v.vasarlo_id = r.vasarlo_id
JOIN rendeles_tetelek rt ON r.rendeles_id = rt.rendeles_id
JOIN termekek t ON rt.termek_id = t.termek_id
WHERE r.rendeles_datum >= '2023-01-01' and r.rendeles_datum<'2023-04-01'
AND t.kategoria = 'Zöldség'
AND rt.termek_id = 2333
AND t.ar > 500;


CREATE INDEX idx_rendeles_datum ON rendelesek(rendeles_datum);
CREATE INDEX idx_termek_kategoria ON termekek(kategoria);
CREATE INDEX idx_vasarlo_id ON rendelesek(vasarlo_id);

CREATE INDEX idx_rendeles_tetelek_termek_id ON rendeles_tetelek(termek_id);


DROP INDEX idx_rendeles_datum;
DROP INDEX idx_termek_kategoria;
DROP INDEX idx_vasarlo_id;
