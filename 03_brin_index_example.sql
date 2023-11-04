CREATE TABLE test_brin (
    id serial PRIMARY KEY,
    event_time timestamp NOT NULL,
    event_value int NOT NULL
);

INSERT INTO test_brin (event_time, event_value)
SELECT
    (current_date - interval '1 day' * generate_series(0, 999)) as event_time,
    generate_series(1, 1000) as event_value;

CREATE INDEX idx_brin_event_time ON test_brin USING brin(event_time);

CREATE INDEX idx_btree_event_time ON test_brin(event_time);

SELECT *
FROM test_brin
WHERE event_time BETWEEN '2023-01-01' AND '2023-02-01';

SELECT pg_size_pretty(pg_relation_size('test_brin'))               AS table_size,
       pg_size_pretty(pg_indexes_size('test_brin'))     AS full_index_size;

SELECT pg_size_pretty(pg_relation_size('test_brin'))               AS table_size,
       pg_size_pretty(pg_relation_size('idx_btree_event_time'))     AS btree_size,
       pg_size_pretty(pg_relation_size('idx_brin_event_time'))  AS brin_size;

