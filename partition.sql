CREATE TABLE sales (
    sale_id SERIAL,
    sale_date DATE NOT NULL,
    amount DECIMAL,
    PRIMARY KEY (sale_id, sale_date)
) PARTITION BY RANGE (sale_date);



CREATE TABLE sales_november PARTITION OF sales
FOR VALUES FROM ('2023-11-01') TO ('2023-11-30');

CREATE TABLE sales_january PARTITION OF sales
FOR VALUES FROM ('2023-01-01') TO ('2023-01-31');

insert into sales (sale_date,amount) values (now(),300);



CREATE INDEX idx_sales_date ON sales (sale_date);



CREATE TABLE sales2 (
    sale_id SERIAL,
    sale_date DATE NOT NULL,
    amount DECIMAL,
    region_id INT,
    PRIMARY KEY (sale_id, region_id)
) PARTITION BY LIST (region_id);

CREATE TABLE sales_north PARTITION OF sales2 FOR VALUES IN (1);
CREATE TABLE sales_south PARTITION OF sales2 FOR VALUES IN (2);
CREATE TABLE sales_east PARTITION OF sales2 FOR VALUES IN (3);
CREATE TABLE sales_west PARTITION OF sales2 FOR VALUES IN (4);


CREATE TABLE sales_hash (
    sale_id SERIAL,
    sale_date DATE NOT NULL,
    amount DECIMAL,
    PRIMARY KEY (sale_id)
) PARTITION BY HASH (sale_id);

CREATE TABLE sales_part1 PARTITION OF sales_hash FOR VALUES WITH (MODULUS 4, REMAINDER 0);
CREATE TABLE sales_part2 PARTITION OF sales_hash FOR VALUES WITH (MODULUS 4, REMAINDER 1);
CREATE TABLE sales_part3 PARTITION OF sales_hash FOR VALUES WITH (MODULUS 4, REMAINDER 2);
CREATE TABLE sales_part4 PARTITION OF sales_hash FOR VALUES WITH (MODULUS 4, REMAINDER 3);

INSERT INTO sales_hash(sale_date, amount)
SELECT '2023-11-14',random() * 100
FROM generate_series(1, 100000);