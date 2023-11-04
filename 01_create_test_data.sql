-- sima számok
create table test_1 (t int);
insert into test_1(t) select random()*100 from generate_series(1,1000000);

-- karakterek generálása
CREATE TABLE lego (
	id serial4 NOT NULL,
	szam int NOT NULL,
	nev text NOT NULL,
	szin text NOT NULL,
	CONSTRAINT lego_pkey PRIMARY KEY (id)
);

INSERT INTO lego(szam, nev, szin)
SELECT
  random() * 100,
  LEFT(md5(random()::text), 6),
  CASE
    WHEN random() <= 0.8 THEN 'piros'
    ELSE CASE
      WHEN random() < 0.5 THEN 'kek'
      ELSE 'sarga'
    END
  END
FROM generate_series(1, 10000);


CREATE TABLE lego_tomi (
	id serial4 NOT NULL,
	szam int NOT NULL,
	nev text NOT NULL,
	szin text NOT NULL,
	CONSTRAINT lego_tomi_pkey PRIMARY KEY (id)
);


INSERT INTO lego_tomi(szam, nev, szin)
SELECT
  random() * 100,
  LEFT(md5(random()::text), 6),
  CASE
    WHEN random() <= 0.8 THEN 'piros'
    ELSE CASE
      WHEN random() < 0.5 THEN 'kek'
      ELSE 'sarga'
    END
  END
FROM generate_series(1, 10000);
