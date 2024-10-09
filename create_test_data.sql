-- sima számok
create table test_1 (t int,k int);
insert into test_1(t,k) select random()*100,random()*100 from generate_series(1,1000000);

-- karakterek generálása
CREATE TABLE lego_zsuzsi (
	id serial4 NOT NULL,
	szam int NOT NULL,
	nev text NOT NULL,
	szin text NOT NULL,
	CONSTRAINT lego_zsuzsi_pkey PRIMARY KEY (id)
);

INSERT INTO lego_zsuzsi(szam, nev, szin)
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

--SELECT * from lego_zsuzsi JOIN lego_tomi lt on lego_zsuzsi.szin = lt.szin;

postgres=# explain analyze SELECT * from lego_zsuzsi JOIN lego_tomi lt on lego_zsuzsi.szam = lt.szam where lego_zsuzsi.szam=70;
                                                               QUERY PLAN
-----------------------------------------------------------------------------------------------------------------------------------------
 Nested Loop  (cost=10.12..270.80 rows=9964 width=40) (actual time=1.113..4.371 rows=9964 loops=1)
   ->  Bitmap Heap Scan on lego_zsuzsi  (cost=5.11..72.79 rows=106 width=20) (actual time=0.386..0.787 rows=106 loops=1)
         Recheck Cond: (szam = 70)
         Heap Blocks: exact=48
         ->  Bitmap Index Scan on idx_lego_zsuzsi_szam  (cost=0.00..5.08 rows=106 width=0) (actual time=0.319..0.319 rows=106 loops=1)
               Index Cond: (szam = 70)
   ->  Materialize  (cost=5.01..73.70 rows=94 width=20) (actual time=0.007..0.018 rows=94 loops=106)
         ->  Bitmap Heap Scan on lego_tomi lt  (cost=5.01..73.23 rows=94 width=20) (actual time=0.707..1.245 rows=94 loops=1)
               Recheck Cond: (szam = 70)
               Heap Blocks: exact=48
               ->  Bitmap Index Scan on idx_lego_tomi_szam  (cost=0.00..4.99 rows=94 width=0) (actual time=0.689..0.689 rows=94 loops=1)
                     Index Cond: (szam = 70)
 Planning Time: 0.942 ms
 Execution Time: 4.897 ms
(14 rows)

postgres=# DROP index idx_lego_zsuzsi_szam;
DROP INDEX
postgres=# DROP index idx_lego_tomi_szam;
DROP INDEX
postgres=# explain analyze SELECT * from lego_zsuzsi JOIN lego_tomi lt on lego_zsuzsi.szam = lt.szam where lego_zsuzsi.szam=70;
                                                      QUERY PLAN
-----------------------------------------------------------------------------------------------------------------------
 Nested Loop  (cost=0.00..502.79 rows=9964 width=40) (actual time=0.083..5.655 rows=9964 loops=1)
   ->  Seq Scan on lego_zsuzsi  (cost=0.00..189.00 rows=106 width=20) (actual time=0.046..1.863 rows=106 loops=1)
         Filter: (szam = 70)
         Rows Removed by Filter: 9894
   ->  Materialize  (cost=0.00..189.47 rows=94 width=20) (actual time=0.000..0.020 rows=94 loops=106)
         ->  Seq Scan on lego_tomi lt  (cost=0.00..189.00 rows=94 width=20) (actual time=0.016..1.357 rows=94 loops=1)
               Filter: (szam = 70)
               Rows Removed by Filter: 9906
 Planning Time: 0.511 ms
 Execution Time: 6.132 ms
(10 rows)
