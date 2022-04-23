-- PostgreSQL Views

SELECT cu.customer_id AS id,
	cu.first_name || ' ' || cu.last_name AS full_name,
	a.address,
	a.postal_code AS zip_code,
	a.phone,
	city.city,
	country.country,
		CASE
			WHEN cu.activebool THEN 'active'
			ELSE 'Inactive'
		END AS notes,
	cu.store_id AS sid
FROM customer cu
	INNER JOIN address a USING(address_id)
	INNER JOIN city USING(city_id)
	INNER JOIN country USING(country_id);
	
CREATE VIEW customer_master AS
SELECT cu.customer_id AS id,
	cu.first_name || ' ' || cu.last_name AS full_name,
	a.address,
	a.postal_code AS zip_code,
	a.phone,
	city.city,
	country.country,
		CASE
			WHEN cu.activebool THEN 'active'
			ELSE 'Inactive'
		END AS notes,
	cu.store_id AS sid
FROM customer cu
	INNER JOIN address a USING(address_id)
	INNER JOIN city USING(city_id)
	INNER JOIN country USING(country_id);
	
SELECT * FROM customer_master;

ALTER VIEW customer_master RENAME TO customer_info;

DROP VIEW IF EXISTS customer_info;

-- Drop View

CREATE VIEW film_master
AS
SELECT film_id, title, release_year,
		length, name category
FROM film
INNER JOIN film_category USING(film_id)
INNER JOIN category USING (category_id);

CREATE VIEW horror_film
AS
SELECT  film_id,
		title, release_year, length
FROM film_master
WHERE category = 'Horror';

CREATE VIEW comedy_film
AS
SELECT film_id, title, release_year, length
FROM film_master
WHERE category = 'Comedy';

CREATE VIEW film_category_stat
AS
SELECT name, COUNT(film_id)
FROM category
INNER JOIN film_category USING(category_id)
INNER JOIN film USING (film_id)
GROUP BY name;

CREATE VIEW film_length_stat
AS
SELECT name, SUM(length) film_length
FROM category
INNER JOIN film_category USING(category_id)
INNER JOIN film USING(film_id)
GROUP BY name;

DROP VIEW comedy_film;

DROP VIEW film_master;

DROP VIEW film_master
CASCADE;

DROP VIEW film_length_stat, film_category_stat;

--Creating PostgreSQL Updatable Views

CREATE VIEW usa_cities AS
SELECT city, country_id
FROM city
WHERE country_id = 103;

SELECT * FROM usa_cities;

INSERT INTO usa_cities(city, country_id)
VALUES('San Jose', 103);

SELECT * FROM city
WHERE country_id = 103
ORDER BY last_update DESC;

DELETE 
FROM usa_cities
WHERE city = 'San Jose';

-- Materialized Views

CREATE MATERIALIZED VIEW rental_by_category
AS
SELECT c.name AS category,
	SUM(p.amount) AS total_sales
FROM(((((payment p 
			 JOIN rental r  ON ((p.rental_id = r.rental_id)))
			 JOIN inventory i ON ((r.inventory_id = i.inventory_id)))
		   	 JOIN film f ON ((i.film_id = f.film_id)))
		  	 JOIN film_category fc ON ((f.film_id = fc.film_id)))
		 	 JOIN category c ON ((fc.category_id = c.category_id)))
GROUP BY  c.name
ORDER BY SUM(p.amount) DESC
WITH NO DATA;

SELECT * FROM rental_by_category;
		
REFRESH MATERIALIZED VIEW rental_by_category;

CREATE UNIQUE INDEX rental_category ON rental_by_category(category);

REFRESH MATERIALIZED VIEW CONCURRENTLY rental_by_category;

