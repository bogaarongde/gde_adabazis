
-- index nélküli keresés
explain analyze SELECT * FROM test_1 where t>90;

-- index készítése
CREATE INDEX t_idx ON test_1(t);

explain analyze select * from test_table where name like 'ef';
explain analyze select * from test_table where name like '%ef%';


-- index készítése
CREATE INDEX test_table_name_idx ON test_table(name);

explain analyze select * from test_table where name like 'ef';
explain analyze select * from test_table where name like '%ef%';

-- index-only scan
CREATE INDEX test_table_id_name_idx ON test_table(id,name);

explain select name from test_table where id = 2;

-- bitmap index-scan
explain select * from test_table where name = 'ef86aad674759fb5ecffc363cc7ac8b3' or name='ef86aad674759fb5ecffc363cc7ac833';


-- ha nem is fut le, mert okos
explain select * from test_table where name = 'ef86aad674759fb5ecffc363cc7ac8b3' and name='ef86aad674759fb5ecffc363cc7ac833';


-- nem használja az indexet, mert úgyis az egész tábla kell kb
explain analyze select name from test_table where id > 2000;