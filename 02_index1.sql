-- karakterek generálása
CREATE TABLE test_table (
	id serial4 NOT NULL,
	t int NOT NULL,
	strtext text NOT NULL,
	CONSTRAINT test_table_pkey PRIMARY KEY (id)
);

INSERT INTO test_table(t, strtext)
SELECT random() * 100, LEFT(md5(random()::text), 6)
FROM generate_series(1, 100000);




-- index nélküli keresés
explain  SELECT t FROM test_table where t>90;

-- index készítése
CREATE INDEX t_idx ON test_table(t);

SELECT t FROM test_table where t=90;


explain select * from test_table where strtext like 'ef';
explain analyze select * from test_table where strtext like '%ef%';


-- index készítése
CREATE INDEX test_table_name_idx ON test_table(strtext);

explain analyze select * from test_table where strtext like 'ef';
explain analyze select * from test_table where strtext like '%ef%';

-- index-only scan
CREATE INDEX test_table_id_name_idx ON test_table(id,strtext);

explain select strtext from test_table where id = 2;

-- bitmap index-scan (ide be kell tenni valami lekérdezett értéket)
explain select * from test_table where strtext = 'ERTEK1' or strtext='ERTEK2';


-- ha nem is fut le, mert okos
explain select * from test_table where strtext = 'ef86aad674759fb5ecffc363cc7ac8b3' and strtext='ef86aad674759fb5ecffc363cc7ac833';


-- nem használja az indexet, mert úgyis az egész tábla kell kb
explain analyze select strtext from test_table where id > 2000;


-- index info:
CREATE EXTENSION pageinspect

select * from bt_page_items('test_table_t_idx', 13) limit 5;
