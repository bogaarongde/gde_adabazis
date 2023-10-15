Nem 1.NF:

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    items TEXT[],
    quantities INT[]
);

INSERT INTO orders (items, quantities) VALUES (ARRAY['apple', 'banana'], ARRAY[3, 2]);

1. NF

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY
);

CREATE TABLE order_items (
    order_id INT REFERENCES orders,
    item TEXT,
    quantity INT
);

INSERT INTO order_items (order_id, item, quantity) VALUES (1, 'apple', 3), (1, 'banana', 2);

Nem 2. NF
CREATE TABLE TeachersSubjects (
    class_id INT NOT NULL,
    teacher_id INT NOT NULL,
    teacher_name VARCHAR(255) NOT NULL,
    subject VARCHAR(255) NOT NULL,
    PRIMARY KEY (teacher_id, class_id)
);

INSERT INTO TeachersSubjects (class_id,teacher_id, teacher_name, subject) VALUES
    (101, 1, 'Mr. Smith' 'Mathematics'),
    (102, 1, 'Mr. Smith' 'Mathematics'),
    (103, 2, 'Mrs. Jones','English'),
    (104, 2, 'Mrs. Jones','English');

2. NF

CREATE TABLE Teachers (
    teacher_id INT PRIMARY KEY,
    teacher_name VARCHAR(255) NOT NULL
);

INSERT INTO Teachers (teacher_id, teacher_name) VALUES
    (1, 'Mr. Smith'),
    (2, 'Mrs. Jones');
CREATE TABLE TeacherSubjects (
    class_id INT NOT NULL,
    teacher_id INT NOT NULL REFERENCES Teachers(teacher_id),
    subject VARCHAR(255) NOT NULL,
    PRIMARY KEY (teacher_id, class_id)
);

INSERT INTO TeacherSubjects (class_id, teacher_id, subject) VALUES
    (101, 1, 'Mathematics'),
    (102, 1, 'Mathematics'),
    (103, 2, 'English'),
    (104, 2, 'English');

Nem 3. NF
CREATE TABLE employees (
    employee_id SERIAL PRIMARY KEY,
    name TEXT,
    department TEXT,
    department_location TEXT
);

INSERT INTO employees (name, department, department_location) VALUES ('John Doe', 'HR', 'Building 1');

3. NF

CREATE TABLE departments (
    department_id SERIAL PRIMARY KEY,
    name TEXT,
    location TEXT
);

CREATE TABLE employees (
    employee_id SERIAL PRIMARY KEY,
    name TEXT,
    department_id INT REFERENCES departments
);

INSERT INTO departments (name, location) VALUES ('HR', 'Building 1');
INSERT INTO employees (name, department_id) VALUES ('John Doe', 1);

