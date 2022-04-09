-- Trigger

CREATE TABLE tg_employees(
	id INT GENERATED ALWAYS AS IDENTITY,
	first_name VARCHAR(40) NOT NULL,
	last_name VARCHAR(40) NOT NULL,
	PRIMARY KEY(id)
);

CREATE TABLE tg_employees_audits(
	id INT GENERATED ALWAYS AS IDENTITY,
	employee_id INT NOT NULL,
	last_name VARCHAR(40) NOT NULL,
	changed_on TIMESTAMP(6) NOT NULL
);

CREATE OR REPLACE FUNCTION log_last_name_changes()
	RETURNS TRIGGER
	LANGUAGE PLPGSQL
	AS
$$
BEGIN
	IF NEW.last_name <> OLD.last_name THEN
		INSERT INTO tg_employees_audits(employee_id, last_name, changed_on)
		VALUES(OLD.id, OLD.last_name, now());
		
	END IF;
	
	RETURN NEW;
END;
$$

CREATE TRIGGER last_name_changes
	BEFORE UPDATE
	ON tg_employees
	FOR EACH ROW
	EXECUTE PROCEDURE log_last_name_changes();
	
INSERT INTO tg_employees(first_name, last_name)
VALUES('John', 'Doe'),
	  ('Lily', 'Bush');
	  
SELECT * FROM tg_employees;

SELECT * FROM tg_employees_audits;

UPDATE tg_employees
SET last_name = 'Xy1'
WHERE id = 2;


CREATE TRIGGER last_name_changes1
	AFTER UPDATE
	ON tg_employees
	FOR EACH ROW
	EXECUTE PROCEDURE log_last_name_changes();




		
