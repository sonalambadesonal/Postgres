-- Understanding PostgreSQL Constraints

--Primary Key
CREATE TABLE po_headers(
	po_no INTEGER PRIMARY KEY,
	venndor_no INTEGER,
	description TEXT,
	shipping_address TEXT
);

CREATE TABLE po_items(
	po_no INTEGER,
	item_no INTEGER,
	product_no INTEGER,
	qty INTEGER,
	net_price NUMERIC,
	PRIMARY KEY(po_no, item_no)
);

CREATE TABLE products_no_primary(
	product_no INTEGER,
	description TEXT,
	product_cost NUMERIC
);

ALTER TABLE products_no_primary ADD PRIMARY KEY(product_no);

CREATE TABLE vendors(
	name VARCHAR(255)
);

INSERT INTO vendors(name)
VALUES('Microsoft'),
	('IBM'),
	('Apple'),
	('Samsung');
SELECT * FROM vendors;

ALTER TABLE vendors ADD COLUMN ID SERIAL PRIMARY KEY;

ALTER TABLE products_no_primary DROP CONSTRAINT products_no_primary_pkey;

-- Foreign Key
CREATE TABLE customers_fk(
	customer_id INT  GENERATED ALWAYS AS IDENTITY,
	customer_name VARCHAR(255) NOT NULL,
	PRIMARY KEY(customer_id)
);

DROP TABLE IF EXISTS contacts_fk;

CREATE TABLE contacts_fk(
	contact_id INT GENERATED ALWAYS AS IDENTITY,
	customer_id INT,
	contact_name VARCHAR(255) NOT NULL,
	phone VARCHAR(15),
	email VARCHAR(100),
	PRIMARY KEY(contact_id),
	CONSTRAINT fk_customer
		FOREIGN KEY(customer_id)
			REFERENCES customers_fk(customer_id)
);

INSERT INTO customers_fk(customer_name)
VALUES('BlueBird Inc'),
      ('Dolphin LLC');	
	  
INSERT INTO contacts_fk(customer_id, contact_name, phone, email)
VALUES(2,'John Doe','(408)-111-1234','john.doe@bluebird.dev'),
      (2,'Jane Doe','(408)-111-1235','jane.doe@bluebird.dev'),
      (2,'David Wright','(408)-222-1234','david.wright@dolphin.dev');

INSERT INTO contacts_fk(customer_id, contact_name, phone, email)
VALUES(3, 'Tumba Gumba', '58758755', 'tumba.bumba@gmail.com');

DELETE FROM customers_fk
WHERE customer_id = 2;

DROP TABLE IF EXISTS customers_fk CASCADE;
DROP TABLE IF EXISTS contacts_fk;

CREATE TABLE customers_fk(
	customer_id INT  GENERATED ALWAYS AS IDENTITY,
	customer_name VARCHAR(255) NOT NULL,
	PRIMARY KEY(customer_id)
);

CREATE TABLE contacts_fk(
	contact_id INT GENERATED ALWAYS AS IDENTITY,
	customer_id INT,
	contact_name VARCHAR(255) NOT NULL,
	phone VARCHAR(15),
	email VARCHAR(100),
	PRIMARY KEY(contact_id),
	CONSTRAINT fk_customer
		FOREIGN KEY(customer_id)
			REFERENCES customers_fk(customer_id)
				ON DELETE SET NULL
);

INSERT INTO customers_fk(customer_name)
VALUES('BlueBird Inc'),
      ('Dolphin LLC');	   
	   
INSERT INTO contacts_fk(customer_id, contact_name, phone, email)
VALUES(1,'John Doe','(408)-111-1234','john.doe@bluebird.dev'),
      (1,'Jane Doe','(408)-111-1235','jane.doe@bluebird.dev'),
      (2,'David Wright','(408)-222-1234','david.wright@dolphin.dev');

DELETE FROM customers_fk
WHERE customer_id = 1;

SELECT * FROM contacts_fk;


CREATE TABLE contacts_fk(
	contact_id INT GENERATED ALWAYS AS IDENTITY,
	customer_id INT,
	contact_name VARCHAR(255) NOT NULL,
	phone VARCHAR(15),
	email VARCHAR(100),
	PRIMARY KEY(contact_id),
	CONSTRAINT fk_customer
		FOREIGN KEY(customer_id)
			REFERENCES customers_fk(customer_id)
				ON DELETE CASCADE
);

-- CHECK Constraint

CREATE TABLE employees_check(
	id SERIAL PRIMARY KEY,
	first_name VARCHAR(50),
	last_name VARCHAR(50),
	birth_date DATE CHECK (birth_date > '1900-01-01'),
	joined_date DATE CHECK (joined_date > birth_date),
	salary NUMERIC CHECK (salary > 0)	
);

INSERT INTO employees_check(first_name, last_name, birth_date, joined_date, salary)
VALUES('John', 'Doe', '1972-01-01', '2015-07-01', - 100000);

DROP TABLE IF EXISTS price_list;

CREATE TABLE price_list(
	id SERIAL PRIMARY KEY,
	product_id INT NOT NULL,
	price NUMERIC NOT NULL,
	discount NUMERIC NOT NULL,
	valid_from DATE NOT NULL,
	valid_to DATE NOT NULL
);

ALTER TABLE price_list
ADD CONSTRAINT price_discount_check
CHECK(
	price >0 AND discount >= 0 AND price > discount
);

ALTER TABLE price_list
ADD CONSTRAINT valid_range_check
CHECK(
	valid_to >= valid_from
);

--UNIQUE Constraint
CREATE TABLE person(
	id SERIAL PRIMARY KEY,
	first_name VARCHAR (50),
	last_name VARCHAR (50),
	email VARCHAR (50) UNIQUE
);

INSERT INTO person(first_name, last_name, email)
VALUES('john','doe','j.doe@postgresqltutorial.com');
INSERT INTO person(first_name,last_name,email)
VALUES('jack','doe','j.doe@postgresqltutorial.com');

CREATE TABLE equiment(
	id SERIAL PRIMARY KEY,
	name VARCHAR(50) NOT NULL,
	equip_id VARCHAR(16) NOT NULL
);

CREATE UNIQUE INDEX CONCURRENTLY equiment_equip_id ON equiment(equip_id);

ALTER TABLE equiment
ADD CONSTRAINT unique_equip_id
UNIQUE USING INDEX equiment_equip_id;

SELECT datid,datname,usename,state
FROM pg_stat_activity;