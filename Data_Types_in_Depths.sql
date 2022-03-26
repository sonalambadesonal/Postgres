-- Data Types in Depth

--Boolean Data Type

CREATE TABLE stock_availability(
	product_id INT NOT NULL,
	available BOOLEAN NOT NULL
);

INSERT INTO stock_availability(product_id, available)
VALUES(100, TRUE),
	(200, FALSE),
	(300, 't'),
	(400, 'f'),
	(500, 'yes'),
	(600, 'no'),
	(700, '1'),
	(800, '0');
	
SELECT * FROM stock_availability
WHERE available = TRUE;

SELECT * FROM stock_availability
WHERE available = FALSE;

ALTER TABLE stock_availability
ALTER COLUMN available
SET DEFAULT FALSE;

INSERT INTO stock_availability(product_id)
VALUES(900);

SELECT * FROM stock_availability
WHERE product_id = 900;

--CHAR, VARCHAR, and TEXT

CREATE TABLE character_tests(
	id SERIAL PRIMARY KEY,
	x CHAR(1),
	y VARCHAR(10),
	z TEXT
);

INSERT INTO character_tests(x, y, z)
VALUES('Yes','This is a test for varchar','This is a very long text for the PostgreSQL text column'
	);


INSERT INTO character_tests(x, y, z)
VALUES('Y','This is a test for varchar','This is a very long text for the PostgreSQL text column'
	);

INSERT INTO character_tests(x,y,z)
VALUES(	'Y','varchar(n)','This is a very long text for the PostgreSQL text column'
	);
	
SELECT * FROM character_tests;

--NUMERIC Type

CREATE TABLE products_numeric(
	id SERIAL PRIMARY KEY,
	name VARCHAR(200) NOT NULL,
	price NUMERIC(5,2)
);

INSERT INTO products_numeric(name, price)
VALUES('Phone',500.215), 
       ('Tablet',500.214);
	   
SELECT * FROM products_numeric;

INSERT INTO products_numeric(name, price)
VALUES('Phone', 123.21);

UPDATE products_numeric
SET price = 'NaN'
WHERE id = 1;

SELECT * FROM products_numeric
ORDER BY price DESC;

--Integer Data Types
CREATE TABLE books_int(
	book_id SERIAL PRIMARY KEY,
	title VARCHAR(255) NOT NULL,
	pages SMALLINT NOT NULL CHECK(pages > 0)
);

CREATE TABLE cities(
	city_id SERIAL PRIMARY KEY,
	city_name VARCHAR(255) NOT NULL,
	population INT NOT NULL CHECK(population >= 0)
);

--DATE data type

CREATE TABLE documents(
	document_id SERIAL PRIMARY KEY,
	header_text VARCHAR(255) NOT NULL,
	posting_date DATE NOT NULL DEFAULT CURRENT_DATE
);

INSERT INTO documents(header_text)
VALUES('Billing to customer XYZ');

SELECT * FROM documents;

CREATE TABLE employees_date(
	employee_id SERIAL PRIMARY KEY,
	first_name VARCHAR(255),
	last_name VARCHAR(255),
	birth_date DATE NOT NULL,
	hire_date DATE NOT NULL
);

INSERT INTO employees_date(first_name,last_name, birth_date, hire_date)
VALUES('Shannon','Freeman','1980-01-01','2005-01-01'),
	   ('Sheila','Wells','1978-02-05','2003-01-01'),
	   ('Ethel','Webb','1975-01-01','2001-01-01');
	   
SELECT NOW()::time;

SELECT CURRENT_DATE;

SELECT TO_CHAR(NOW()::DATE, 'dd/mm/yyyy');

SELECT TO_CHAR(NOW()::DATE, 'Mon dd, yyyy');

SELECT first_name, last_name,
	NOW() - hire_date AS diff
FROM employees_date;

SELECT employee_id, first_name, last_name,
	AGE(birth_date) AS age
FROM employees_date;


SELECT employee_id, first_name, last_name,
	AGE('2015-01-01', birth_date) 
FROM employees_date;

SELECT employee_id, first_name, last_name,
	EXTRACT (YEAR FROM birth_date) AS year,
	EXTRACT (MONTH FROM birth_date) AS month,
	EXTRACT (DAY FROM birth_date) AS day
FROM employees_date;

--Timestamp Data Types

SELECT typname, typlen
FROM pg_type
WHERE typname ~ '^timestamp';

CREATE TABLE timestamp_demo(
	ts TIMESTAMP,
	tstz TIMESTAMPTZ
);

SET timezone = 'EUROPE/BERLIN';

SHOW TIMEZONE;

INSERT INTO timestamp_demo(ts, tstz)
VALUES('2016-06-22 19:10:25-07','2016-06-22 19:10:25-07');

SELECT * FROM timestamp_demo;

SET timezone = 'ASIA/DILI';

SELECT NOW();
SELECT CURRENT_TIMESTAMP;
SELECT CURRENT_TIME;
SELECT TIMEOFDAY();

SHOW TIMEZONE;

SELECT timezone('America/New_York','2016-06-01 00:00');

SELECT timezone('America/New_York','2016-06-01 00:00'::timestamptz);

-- Interval Data Type

SELECT NOW(),
	NOW() - INTERVAL '1 year 3 hours 20 minutes' AS lastyear;
	
SET intervalstyle = 'sql_standard';
SELECT INTERVAL '6 years 5 months 4 days 3 hours 2 minutes 1 second';

SET intervalstyle = 'postgres';
SELECT INTERVAL '6 years 5 months 4 days 3 hours 2 minutes 1 second';

SET intervalstyle = 'postgres_verbose';
SELECT INTERVAL '6 years 5 months 4 days 3 hours 2 minutes 1 second';

SET intervalstyle = 'iso_8601';
SELECT INTERVAL '6 years 5 months 4 days 3 hours 2 minutes 1 second';

SELECT INTERVAL '2h 50m' + INTERVAL '10m';

SELECT INTERVAL '2h 50m' - INTERVAL '50m';

SELECT 600 * INTERVAL '1 minute';

SELECT TO_CHAR(INTERVAL '17h 20m 05s', 'HH24:MI:SS');

SELECT EXTRACT(MINUTE FROM INTERVAL '5 hours 21 minutes');

SELECT justify_days(INTERVAL '30 days'),
	justify_hours(INTERVAL '24 hours');
	
SELECT justify_interval(INTERVAL '1 year - 1 hour');

--TIME Data Type

CREATE TABLE shifts(
	id SERIAL PRIMARY KEY,
	shift_name VARCHAR NOT NULL,
	start_at TIME NOT NULL,
	end_at TIME NOT NULL
);

INSERT INTO shifts(shift_name, start_at, end_at)
VALUES('Morning', '08:00:00', '12:00:00'),
      ('Afternoon', '13:00:00', '17:00:00'),
      ('Night', '18:00:00', '22:00:00');
	  
SELECT * FROM shifts;

SELECT CURRENT_TIME(5);

SELECT LOCALTIME;

SELECT LOCALTIME(1);

SELECT LOCALTIME AT TIME ZONE 'IST';

SELECT LOCALTIME,
	EXTRACT (HOUR FROM LOCALTIME) AS hours,
	EXTRACT (MINUTE FROM LOCALTIME) AS minutes,
	EXTRACT (SECOND FROM LOCALTIME) AS seconds,
	EXTRACT (MILLISECONDS FROM LOCALTIME) AS millisecond;
	
SELECT TIME '10:00' - TIME '02:00';

SELECT LOCALTIME + INTERVAL '2 hours' AS result;

--UUID Data Type

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

SELECT uuid_generate_v1();

SELECT uuid_generate_v4();

CREATE TABLE contacts_uuid(
	contact_id uuid DEFAULT uuid_generate_v4(),
	first_name VARCHAR NOT NULL,
	last_name VARCHAR NOT NULL,
	email VARCHAR NOT NULL,
	phone VARCHAR,
	PRIMARY KEY(contact_id)
);

INSERT INTO contacts_uuid(first_name, last_name, email, phone)
VALUES (
        'John',
        'Smith',
        'john.smith@example.com',
        '408-237-2345'
    ),
    (
        'Jane',
        'Smith',
        'jane.smith@example.com',
        '408-237-2344'
    ),
    (
        'Alex',
        'Smith',
        'alex.smith@example.com',
        '408-237-2343'
    );
	
SELECT * FROM contacts_uuid;

--Array
CREATE TABLE contacts_array(
	id SERIAL PRIMARY KEY,
	name VARCHAR (100),
	phones TEXT []
);

INSERT INTO contacts_array(name, phones)
VALUES('John Doe', ARRAY['(408)-589-5846', '(408)-589-5555']);

INSERT INTO contacts_array(name, phones)
VALUES('Lily Bush','{"(408)-589-5841"}'),
      ('William Gate','{"(408)-589-5842","(408)-589-58423"}');
	  
SELECT * FROM contacts_array;

SELECT name, phones[1]
FROM contacts_array;

SELECT name 
FROM contacts_array
WHERE phones[2] =  '(408)-589-58423'; 

UPDATE contacts_array
SET phones[2] = '(408)-589-5843'
WHERE id = 3;

SELECT id, name, phones[2]
FROM contacts_array
WHERE id = 3;

UPDATE contacts_array
SET phones = '{"(408)-589-5843"}'
WHERE id = 3;

SELECT * 
FROM contacts_array
WHERE id = 3;

SELECT name, phones
FROM contacts_array
WHERE '(408)-589-5555' = ANY(phones);

SELECT name,unnest(phones)
FROM contacts_array;