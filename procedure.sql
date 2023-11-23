-- Tábla létrehozása
CREATE TABLE employees (
  employee_id SERIAL PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  salary DECIMAL(10, 2) NOT NULL
);

-- Adatok feltöltése
INSERT INTO employees (name, salary)
VALUES
  ('John Doe', 50000.00),
  ('Jane Smith', 55000.00),
  ('Bob Johnson', 60000.00);


CREATE OR REPLACE PROCEDURE calculate_bonus2(IN in_employee_id NUMERIC) AS $$
DECLARE
    employee_salary DECIMAL;
BEGIN
  SELECT INTO employee_salary salary FROM employees where  employee_id = in_employee_id;
  RAISE NOTICE 'bonus: %',employee_salary * 0.05;
END;
$$ LANGUAGE plpgsql;

-- IN paraméterek használata
CALL calculate_bonus2( 50000);


CREATE OR REPLACE PROCEDURE get_employee_name_and_salary(IN emp_id NUMERIC, OUT emp_name VARCHAR, OUT emp_salary DECIMAL) AS $$
BEGIN
  -- Az OUT paraméterek feltöltése
  SELECT name, salary INTO emp_name, emp_salary FROM employees WHERE employee_id = emp_id;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE PROCEDURE increment_and_double(INOUT num INT) AS $$
BEGIN
  -- Az INOUT paraméter módosítása
  num := num + 1;
  num := num * 2;
END;
$$ LANGUAGE plpgsql;


-- OUT paraméterek használata
DO $$
DECLARE
  employee_name VARCHAR;
  employee_salary DECIMAL;
BEGIN
  CALL get_employee_name_and_salary(2, employee_name, employee_salary);
  -- Eredmények kiírása
  RAISE NOTICE 'Employee Name: %, Salary: %', employee_name, employee_salary;
END;
$$;


-- INOUT paraméterek használata
DO $$
DECLARE
  num INT := 5;
BEGIN
  CALL increment_and_double(num);
  -- Módosított érték kiírása
  RAISE NOTICE 'Modified Value: %', num;
END;
$$;

