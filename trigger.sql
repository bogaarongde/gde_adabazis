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
AFTER INSERT ON employees
FOR EACH ROW
EXECUTE FUNCTION validate_data();
