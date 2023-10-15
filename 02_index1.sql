
-- index nélküli keresés
explain analyze SELECT * FROM test_1 where t>90;

-- index készítése
CREATE INDEX t_idx ON test_1(t);

explain analyze select * from test_table where name like 'ef';
explain analyze select * from test_table where name like '%ef%';


-- index készítése

explain analyze select * from test_table where name like 'ef';
explain analyze select * from test_table where name like '%ef%';
