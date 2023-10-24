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
    subject_id INT NOT NULL,
    teacher_id INT NOT NULL,
    subject VARCHAR(255) NOT NULL,
    teacher_name VARCHAR(255) NOT NULL,
    PRIMARY KEY (teacher_id, subject_id)
);

INSERT INTO TeachersSubjects (subject_id,teacher_id,subject,teacher_name) VALUES
    (101, 1, 'Mathematics','Mr. Smith'),
    (102, 1, 'Algebra','Mr. Smith'),
    (103, 2, 'English', 'Mrs. Jones'),
    (101, 2, 'Mathematics', 'Mrs. Jones');

2. NF

CREATE TABLE Teachers (
    teacher_id INT PRIMARY KEY,
    teacher_name VARCHAR(255) NOT NULL
);

CREATE TABLE Subjects (
    subject_id INT PRIMARY KEY,
    subject_name VARCHAR(255) NOT NULL
);

INSERT INTO Teachers (teacher_id, teacher_name) VALUES
    (1, 'Mr. Smith'),
    (2, 'Mrs. Jones');

INSERT INTO Subjects (subject_id, subject_name) VALUES
    (101, 'Mathematics'),
    (102, 'Algebra'),
    (103, 'English');

CREATE TABLE TeacherSubjects (
    subject_id INT NOT NULL,
    teacher_id INT NOT NULL REFERENCES Teachers(teacher_id),
    PRIMARY KEY (teacher_id, subject_id)
);

INSERT INTO TeacherSubjects (subject_id, teacher_id) VALUES
    (101, 1),
    (102, 1),
    (103, 2),
    (101, 2);

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

