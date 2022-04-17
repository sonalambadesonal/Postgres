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

--DROP TRIGGER

CREATE FUNCTION check_staff_user()
	RETURNS TRIGGER

AS $$
BEGIN
	IF length(NEW.username) <  8 OR NEW.username IS NULL THEN
		RAISE EXCEPTION 'The username cannot be less than 8 characters';
		
	END IF;
	IF NEW.NAME IS NULL THEN
		RAISE EXCEPTION 'Username cannot be NULL';
	
	END IF;
	RETURN NEW;
END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER username_check
	BEFORE INSERT OR UPDATE
ON staff
FOR EACH ROW 
	EXECUTE PROCEDURE check_staff_user();
	
SELECT * FROM staff;

INSERT INTO staff(username)
VALUES (NULL);

DROP TRIGGER username_check
ON staff;

--ALTER TRIGGER

DROP TABLE IF EXISTS employees_alter_trigger;

CREATE TABLE employees_alter_trigger(
	employee_id INT GENERATED  ALWAYS AS IDENTITY,
	first_name VARCHAR(50) NOT NULL,
	last_name VARCHAR(50) NOT NULL,
	salary DECIMAL(11,2) NOT NULL DEFAULT 0,
	PRIMARY KEY(employee_id) 	
);

CREATE OR REPLACE FUNCTION check_salary()
	RETURNS TRIGGER
	LANGUAGE PLPGSQL
	AS
$$
BEGIN
	IF (NEW.salary - OLD.salary) / OLD.salary >= 1 THEN
		RAISE 'The Salary Increment cannot that high.';
	END IF;
	RETURN NEW;
END;
$$

CREATE TRIGGER before_update_salary
	BEFORE UPDATE
	ON employees_alter_trigger
	FOR EACH ROW
	EXECUTE PROCEDURE check_salary(); 
	
SELECT * FROM employees_alter_trigger;

INSERT INTO employees_alter_trigger(first_name,last_name,salary)
VALUES('John', 'Baba', 10);

UPDATE employees_alter_trigger
SET salary = 200
WHERE employee_id = 2;

ALTER TRIGGER before_update_salary
ON employees_alter_trigger
RENAME TO salary_before_update;

--Disable Triggers

ALTER TABLE employees_alter_trigger
DISABLE TRIGGER salary_before_update;

--Enable Triggers
ALTER TABLE employees_alter_trigger
ENABLE TRIGGER salary_before_update;
		





		
