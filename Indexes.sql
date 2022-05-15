--Indexes
--Create Index

SELECT * FROM address
WHERE phone = '223664661973';

EXPLAIN SELECT * FROM address
WHERE phone = '223664661973';

CREATE INDEX idx_address_phone
ON address(phone);

CREATE INDEX idx_actor_first_name
ON actor(first_name);

--DROP INDEX

SELECT * FROM actor
WHERE first_name = 'John';

EXPLAIN SELECT * FROM actor
WHERE first_name = 'John';

DROP INDEX idx_actor_first_name;

-- LIST INDEX

SELECT indexname, indexdef
FROM pg_indexes
WHERE tablename = 'customer';

SELECT tablename, indexname, indexdef
FROM pg_indexes
WHERE tablename LIKE 'c%'
ORDER BY tablename, indexname;

--Index Types
--Unique Index

CREATE TABLE employees(
	employee_id SERIAL PRIMARY KEY,
	first_name VARCHAR(255) NOT NULL,
	last_name VARCHAR(255) NOT NULL,
	email VARCHAR(255) UNIQUE
);

SELECT tablename,  indexname, indexdef
FROM pg_indexes
WHERE tablename = 'employees';

ALTER TABLE employees
ADD mobile_phone VARCHAR(20);

CREATE UNIQUE INDEX idx_employees_mobile_phone
ON employees(mobile_phone);

INSERT INTO employees(first_name, last_name,email, mobile_phone)
VALUES('John', 'Doe', 'john.doe@postgresqltutorial.com', '(408)-555-1234');


INSERT INTO employees(first_name, last_name, email, mobile_phone)
VALUES('Mary', 'Jane', 'mary.jane@postgresqltutorial.com', '(408)-555-1234');

ALTER TABLE employees
ADD work_phone VARCHAR(20),
ADD extension VARCHAR(5);

CREATE UNIQUE INDEX idx_employees_workphone
ON employees(work_phone, extension);

INSERT INTO employees(first_name, last_name, work_phone, extension)
VALUES('Lily', 'Bush', '(408)-333-1234', '1212');

INSERT INTO employees(first_name, last_name, work_phone, extension)
VALUES('John', 'Doe', '(408)-333-1234', '1211');

INSERT INTO employees(first_name, last_name, work_phone, extension)
VALUES('Tommy', 'Stark', '(408)-333-1234', '1211');

-- Index ON Expression

SELECT customer_id, first_name, last_name
FROM customer 
WHERE last_name = 'Purdy';

EXPLAIN
SELECT customer_id, first_name, last_name
FROM customer 
WHERE last_name = 'Purdy';

EXPLAIN
SELECT customer_id, first_name, last_name
FROM customer 
WHERE LOWER(last_name) = 'purdy';

CREATE INDEX idx_ic_last_name
ON customer(LOWER(last_name));

