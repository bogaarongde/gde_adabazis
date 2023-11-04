
1. Read Uncommitted Isolation Level (nincs ilyen postgresql-ben)

CREATE TABLE items (
    id serial PRIMARY KEY ,
    item_name varchar(255),
    stock int default 10
);
insert into items (item_name) values ('aso');
insert into items (item_name) values ('kapa');
insert into items (item_name) values ('nagyharang');
-- Console 1
BEGIN TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
SELECT * FROM items WHERE id = 1;

-- Console 2
UPDATE items SET stock = stock - 1 WHERE id = 1;

-- Console 1
SELECT * FROM items WHERE id = 1;
COMMIT;


2. Read Committed Isolation Level
-- Console 1
BEGIN TRANSACTION ISOLATION LEVEL READ COMMITTED;
SELECT * FROM items WHERE id = 1;

-- Console 2
UPDATE items SET stock = stock - 1 WHERE id = 1;
COMMIT;

-- Console 1
SELECT * FROM items WHERE id = 1;
COMMIT;

3. Repeatable Read Isolation Level

-- Console 1
BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ;
SELECT * FROM items WHERE id = 1;

-- Console 2
UPDATE items SET stock = stock - 1 WHERE id = 1;
COMMIT;

-- Console 1
SELECT * FROM items WHERE id = 1;
COMMIT;

4. Serializable Isolation Level

-- Console 1
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SELECT * FROM items WHERE id = 1;

-- Console 2
UPDATE items SET stock = stock - 1 WHERE id = 1;
COMMIT;

-- Console 1
SELECT * FROM items WHERE id = 1;
COMMIT;

5. LOST UPDATE
-- Console 1

SELECT stock from items where id=1;
UPDATE items set stock=100+10 where id=1;

-- Console 2
UPDATE items set stock=100+20 where id=1;


6. PHANTOM READ

-- Console 1
BEGIN TRANSACTION;
SELECT sum(stock) FROM items WHERE stock >10;

-- Console 2
INSERT INTO items (item_name,stock) VALUES ('csapagy',20);

-- Console 1
SELECT sum(stock) FROM items WHERE stock >10;
COMMIT;


7. NON-REPEATABLE READ

-- Console 1
BEGIN TRANSACTION;
SELECT * FROM items WHERE stock >10;

-- Console 2
UPDATE items SET stock=50 WHERE id=1;

-- Console 1
SELECT * FROM items WHERE stock >10;
COMMIT;

