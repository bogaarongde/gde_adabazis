CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    user_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL,
    price DECIMAL NOT NULL
);

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    product_id INT NOT NULL,
    order_group_id INT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    FOREIGN KEY (order_group_id) REFERENCES order_groups(order_group_id)
);

-- Order groups tábla, amely csoportosítja az ordereket
CREATE TABLE order_groups (
    order_group_id SERIAL PRIMARY KEY,
    order_date TIMESTAMP NOT NULL
);

INSERT INTO order_groups (order_date)
SELECT
    timestamp '2023-01-01 10:00:00' + random() * (timestamp '2023-12-31 10:00:00' - timestamp '2023-01-01 10:00:00')
FROM generate_series(1,1000);


-- Felhasználók
INSERT INTO users (user_name, email)
SELECT
    md5(random()::text),
    md5(random()::text) || '@example.com'
FROM generate_series(1,10000);

-- Termékek
INSERT INTO products (product_name, price)
SELECT
    'Product ' || generate_series,
    (random() * 100)::INT
FROM generate_series(1,50);

-- Rendelések
DO $$
DECLARE
    _order_group_id INT;
    _user_id INT;
    _product_id INT;
    _order_count INT := 100000; -- Változtatható a kívánt sorok számára
BEGIN
    FOR i IN 1.._order_count LOOP
        -- Létrehoz egy order_group-ot minden iterációban
        INSERT INTO order_groups (order_date) VALUES (CURRENT_DATE - (random() * 30)::int)
        RETURNING order_group_id INTO _order_group_id;

        -- Minden order_group-hoz létrehoz 1-10 rendelést
        SELECT user_id FROM users ORDER BY random() LIMIT 1 INTO _user_id;
        FOR j IN 1..((random() * 10)::int + 1) LOOP
            SELECT product_id FROM products ORDER BY random() LIMIT 1 INTO _product_id;

            INSERT INTO orders (user_id, product_id, order_group_id)
            VALUES (_user_id, _product_id, _order_group_id);
        END LOOP;
    END LOOP;
END $$;

-- indexeléshez (product_id, email)

EXPLAIN ANALYZE
SELECT * FROM orders
JOIN users ON orders.user_id = users.user_id
JOIN products ON orders.product_id = products.product_id
WHERE users.email LIKE 'c3ca215b03d54a0f40f9b45b33d26b33@example.com';

EXPLAIN ANALYZE
SELECT product_name, count(order_id) as countorder FROM products
JOIN orders ON products.product_id = orders.product_id
GROUP BY product_name
HAVING count(order_id) > 12000;

CREATE INDEX idx_user_email ON users(email);
CREATE INDEX idx_order_user_id ON orders(user_id);
CREATE INDEX idx_order_product_id ON orders(product_id);