CREATE SCHEMA zoldseg;

SET search_path TO zoldseg,public;

CREATE TABLE Suppliers (
    supplier_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    contact_info TEXT
);

INSERT INTO Suppliers (name, contact_info) VALUES
('GreenVeggies', 'contact@greenveggies.com'),
('FreshFruits', 'contact@freshfruits.com');

CREATE TABLE Products (
    product_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    price DECIMAL NOT NULL,
    quantity DECIMAL NOT NULL,
    supplier_id INT REFERENCES Suppliers(supplier_id)
);

INSERT INTO Products (name, price, quantity, supplier_id) VALUES
('Tomato', 2.5,10, 1),
('Banana', 1.2,20, 2);

CREATE TABLE Customers (
    customer_id SERIAL PRIMARY KEY,
    cust_name VARCHAR(255) NOT NULL,
    contact_info TEXT
);

INSERT INTO Customers (cust_name, contact_info) VALUES
('John Doe', 'johndoe@gmail.com'),
('Jane Smith', 'janesmith@gmail.com');

CREATE TABLE Orders (
    order_id SERIAL PRIMARY KEY,
    order_type TEXT NULL,
    customer_id INT REFERENCES Customers(customer_id),
    order_date DATE NOT NULL,
    total_price DECIMAL NOT NULL
);

INSERT INTO Orders (customer_id, order_type, order_date, total_price) VALUES
(1, 'VE', '2023-10-14', 5.0),
(2, 'VE', '2023-10-15', 3.2);

CREATE TABLE OrderItems (
    order_id INT REFERENCES Orders(order_id),
    product_id INT REFERENCES Products(product_id),
    quantity INT NOT NULL,
    PRIMARY KEY (order_id,product_id)
);

INSERT INTO OrderItems (order_id, product_id, quantity) VALUES
(1, 1, 2),
(2, 2, 3);
