--  Import & Export Data

-- Import

DROP TABLE IF EXISTS persons;
CREATE TABLE persons(
	id SERIAL,
	first_name VARCHAR(50),
	last_name VARCHAR(50),
	dob DATE,
	email VARCHAR(255),
	PRIMARY KEY (id)
);

COPY persons(first_name, last_name, dob, email)
FROM 'E:\PostgresSQL\persons.csv'
DELIMITER ','
CSV HEADER;

SELECT * from persons;

TRUNCATE TABLE persons
RESTART IDENTITY;

-- EXPORT
COPY persons TO 'E:\PostgresSQL\persons_db.csv'
DELIMITER ','
CSV HEADER;

COPY persons(first_name,last_name)
TO 'E:\PostgresSQL\persons_partial_db.csv'
DELIMITER ','
CSV HEADER;

COPY persons(email)
TO  'E:\PostgresSQL\persons_email_db.csv'
DELIMITER ',' CSV;


