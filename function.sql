CREATE OR REPLACE FUNCTION add_numbers(a INT, b INT) RETURNS INT AS $$
BEGIN
    RETURN a + b;
END;
$$ LANGUAGE plpgsql;

SELECT add_numbers(1, 2);


CREATE FUNCTION cim_osszeallitasa(utca VARCHAR, varos VARCHAR, OUT teljes_cim VARCHAR) AS $$
BEGIN
  teljes_cim := utca || ', ' || varos;
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION get_customer_balance(in_customer_id INT) RETURNS NUMERIC AS $$
DECLARE
  balance NUMERIC;
BEGIN
  SELECT INTO balance SUM(amount) FROM payments WHERE customer_id = in_customer_id;
  RETURN balance;
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION find_product(product_id INT) RETURNS TEXT AS $$
DECLARE
  product_name TEXT;
BEGIN
  SELECT INTO product_name pname FROM products WHERE id = product_id;
  IF product_name IS NULL THEN
    RAISE 'A termék nem található: %', product_id;
  ELSE RETURN product_name;
END IF;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION add_product(name TEXT, newprice NUMERIC) RETURNS TEXT AS $$
BEGIN
    -- Tegyük fel, hogy a 'price' oszlopon van egy CHECK constraint,
    -- ami azt követeli meg, hogy az ár nagyobb legyen, mint nulla.
    INSERT INTO products (pname, price) VALUES (name, newprice);
    RETURN 'Termék hozzáadva.';
EXCEPTION
    WHEN CHECK_VIOLATION THEN
        RETURN 'Hiba: az árnak nagyobbnak kell lennie, mint nulla.';
    WHEN UNIQUE_VIOLATION THEN
        RETURN 'Hiba: már létezik ilyen nevű termék.';
    WHEN OTHERS THEN
        RAISE 'Ismeretlen hiba történt: %', SQLERRM;
END;
$$ LANGUAGE plpgsql;



DECLARE
  count INT := 0; -- Kezdeti értékkel inicializált egész típusú változó
  my_record RECORD; -- Rekord típusú változó inicializálás nélkül
  my_cursor CURSOR FOR SELECT * FROM my_table; -- Kurzor egy lekérdezéshez



CREATE OR REPLACE FUNCTION process_products() RETURNS VOID AS $$
DECLARE
  cur_products CURSOR FOR SELECT * FROM products;
  rec_product RECORD;
BEGIN
  OPEN cur_products;
  LOOP
    FETCH cur_products INTO rec_product;
    EXIT WHEN NOT FOUND;
    RAISE NOTICE 'Processing product: ID=%, Name=%', rec_product.id, rec_product.pname;
  END LOOP;
  CLOSE cur_products;
END;
$$ LANGUAGE plpgsql;


CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    status varchar,
    total_amount DECIMAL(10, 2)
);
CREATE TABLE order_audit (
    audit_id SERIAL PRIMARY KEY,
    order_id INT,
    changed_on TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    previous_status VARCHAR(50),
    new_status VARCHAR(50)
);

CREATE OR REPLACE FUNCTION complete_customer_orders(cid INT) RETURNS VOID AS $$
DECLARE
    row record;
BEGIN
    FOR row IN
        UPDATE orders SET status = 'Completed'
        WHERE customer_id = cid AND status = 'open'
        RETURNING order_id, status
    LOOP
        INSERT INTO order_audit (order_id, previous_status, new_status)
        VALUES (row.order_id, row.status, 'Completed');
        RAISE NOTICE 'Order ID %, Status %', row.order_id, row.status;
    END LOOP;
EXCEPTION
    WHEN OTHERS THEN
        RAISE;
END;
$$ LANGUAGE plpgsql;


CREATE EXTENSION IF NOT EXISTS plpython3u;

CREATE OR REPLACE FUNCTION complete_customer_orders_py3(cid INT) RETURNS VOID AS $$
orders_to_update = plpy.execute("SELECT order_id, status FROM orders WHERE customer_id = %d AND status = 'open'" % cid)
for order in orders_to_update:
    plpy.execute("UPDATE orders SET status = 'Completed' WHERE order_id = %d" % order['order_id'])
    plpy.execute("INSERT INTO order_audit (order_id, previous_status, new_status) VALUES (%d, '%s', 'Completed')" % (order['order_id'], order['status']))
    plpy.notice("Order ID %d, Status %s" % (order['order_id'], order['status']))
$$ LANGUAGE plpython3u;



INSERT INTO orders (customer_id, order_date, total_amount, status)
SELECT
    (RANDOM() * (1000 - 1) + 1)::INT,
    NOW() - (i || ' days')::INTERVAL,
    (RANDOM() * (1000 - 100) + 100)::DECIMAL(10,2),
    'open'
FROM generate_series(1, 5000) AS i;


CREATE OR REPLACE FUNCTION manipulate_employee_data()
RETURNS TABLE (employee_name VARCHAR, updated_salary DECIMAL) AS $$
BEGIN
  -- Iteráljunk végig az alkalmazottakon és manipuláljuk az adatokat
  FOR employee_name, updated_salary IN
    SELECT name, salary * 1.10 FROM employees
  LOOP
    -- Az eredmények kiadása külön oszlopokban
    RETURN NEXT;
  END LOOP;
END;
$$ LANGUAGE plpgsql;


SELECT * FROM manipulate_employee_data();


