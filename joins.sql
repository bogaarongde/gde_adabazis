-- Nested loop
EXPLAIN (analyze,buffers) SELECT * FROM orders INNER JOIN orderitems ON orders.order_id = orderitems.order_id;


-- Merge Join
