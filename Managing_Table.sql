-- Data Types

-- CREATE TABLE

CREATE TABLE IF NOT EXISTS account(
	user_id SERIAL PRIMARY KEY,
	user_name VARCHAR(50) UNIQUE NOT NULL,
	password VARCHAR(50) NOT NULL,
	email VARCHAR(255) UNIQUE NOT NULL,
	created_on TIMESTAMP NOT NULL,
	last_login TIMESTAMP
);

CREATE TABLE roles(
	role_id SERIAL PRIMARY KEY,
	role_name VARCHAR(255) UNIQUE NOT NULL
);

DROP TABLE IF EXISTS roles;

CREATE TABLE account_roles(
	user_id INT NOT NULL,
	role_id INT NOT NULL,
	grant_date TIMESTAMP,
	PRIMARY KEY (user_id, role_id),
	FOREIGN KEY(role_id)
		REFERENCES roles (role_id),
	FOREIGN KEY (user_id)
		REFERENCES account (user_id)
);

-- SELECT INTO
SELECT title,film_id, rental_duration
INTO TABLE film_r
FROM film
WHERE rating = 'R' AND rental_duration = 5
ORDER BY title;

SELECT * FROM film_r;

SELECT film_id, title, length
INTO TEMP TABLE short_film
FROM film
WHERE length < 60;

SELECT * FROM short_film;

-- CREATE TABLE AS

CREATE TABLE action_film AS
SELECT film_id,
		title,
		release_year,
		length,
		rating
FROM film INNER JOIN film_category USING(film_id)
WHERE category_id = 1;

SELECT * FROM action_film;

CREATE TABLE IF NOT EXISTS film_rating(rating_film, film_count)
AS SELECT rating, COUNT(film_id)
FROM film
GROUP BY rating;

SELECT * FROM film_rating;

-- SERIAL

CREATE TABLE fruits(
	id SERIAL PRIMARY KEY,
	name VARCHAR NOT NULL
);

INSERT INTO fruits(name)
VALUES('Orange');

INSERT INTO fruits(id, name)
VALUES(DEFAULT, 'APPLE');

SELECT * FROM fruits;

SELECT currval(pg_get_serial_sequence('fruits', 'id'));
