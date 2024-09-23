CREATE OR REPLACE FUNCTION log_inserts()
RETURNS TRIGGER AS $$
BEGIN
    RAISE NOTICE 'Új sor beszúrva az ID: %', NEW.employee_id;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER insert_trigger
AFTER INSERT ON employees
FOR EACH ROW
EXECUTE FUNCTION log_inserts();

CREATE OR REPLACE FUNCTION validate_data()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.salary < 2000 THEN
        RAISE EXCEPTION 'Invalid fizetés';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER insert_trigger_validate
BEFORE INSERT ON employees
FOR EACH ROW
EXECUTE FUNCTION validate_data();


CREATE TABLE IF NOT EXISTS employees_audit (
    audit_id SERIAL PRIMARY KEY,
    employee_id INT,
    name VARCHAR(100),
    salary DECIMAL(10, 2),
    operation_type VARCHAR(10),
    changed_on TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE OR REPLACE FUNCTION log_employee_changes() RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'DELETE' THEN
        INSERT INTO employees_audit (employee_id, name, salary, operation_type)
        VALUES (OLD.employee_id, OLD.name, OLD.salary, 'DELETE');
        RETURN OLD;
    ELSIF TG_OP = 'UPDATE' THEN
        INSERT INTO employees_audit (employee_id, name, salary, operation_type)
        VALUES (OLD.employee_id, OLD.name, OLD.salary, 'UPDATE');
        RETURN NEW;
    END IF;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER employee_change_trigger
AFTER UPDATE OR DELETE ON employees
FOR EACH ROW
EXECUTE FUNCTION log_employee_changes();

