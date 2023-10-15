-- sima számok
create table test_1 (t int);
insert into test_1(t) select random()*100 from generate_series(1,1000);

-- karakterek generálása
CREATE TABLE test_table (
	id serial4 NOT NULL,
	"name" text NOT NULL,
	CONSTRAINT test_table_pkey PRIMARY KEY (id)
);

insert into test_table(name) select md5(random()::text) from generate_series(1,1000);
