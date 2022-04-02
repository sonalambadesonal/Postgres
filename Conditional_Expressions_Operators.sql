--Conditional Expressions & Operators

--CASE

SELECT title, length,
	CASE
		WHEN length > 0 AND length <=50 THEN 'Short'
		
		WHEN length > 50 AND length <= 120 THEN 'Medium'
		
		WHEN length > 120 THEN 'Long'
		
	END duration
FROM film
ORDER BY title;

SELECT 
	SUM (CASE 
			WHEN rental_rate = 0.99 THEN 1
			ELSE 0
		END) AS "Economy",
		
	SUM (CASE
			WHEN rental_rate = 2.99 THEN 1
			ELSE 0
		END) AS "Mass",
		
	SUM (CASE
			WHEN rental_rate = 4.99 THEN 1
			ELSE 0
		END) AS "Premium"
FROM film;


SELECT title,
		rating,
		CASE rating
			WHEN 'G' THEN 'General Audiences'
			WHEN 'PG' THEN 'Parental Guidance Suggested'
			WHEN 'PG-13' THEN 'Parents Strongly cautioned'
			WHEN 'R' THEN 'Restricted'
			WHEN 'NC-17' THEN 'Adults Only'
		END rating_description
FROM film
ORDER BY title;

SELECT
	SUM(CASE rating
	   	WHEN 'G' THEN 1
	   	ELSE 0
	END) "Genral Audiences",
	
	SUM(CASE rating
	   	WHEN 'PG' THEN 1
	   	ELSE 0
	 END) "Parental Guidance Suggested",
	
	SUM(CASE rating
	   	WHEN 'PG-13' THEN 1
	   	ELSE 0
	END) "Parents Strongly Cautioned",
	
	SUM(CASE rating
	   	WHEN 'R' THEN 1
	   	ELSE 0
	END) "Restricted",
	
	SUM(CASE rating
	   	WHEN 'NC-17' THEN 1
	   	ELSE 0
	END) "Adults Only"
FROM film;

--COALESCE

SELECT
	COALESCE(1,2);
	
SELECT
	COALESCE(NULL, 1, 2);
	
SELECT
	COALESCE(NULL, 'first', 'TWO');
	
SELECT
	COALESCE(excerpt, LEFT(CONTENT, 150))
FROM posts;

CREATE TABLE items(
	id SERIAL PRIMARY KEY,
	product VARCHAR(100) NOT NULL,
	price NUMERIC NOT NULL,
	discount NUMERIC
);

INSERT INTO items(product, price, discount)
VALUES('A', 1000 ,10),
	('B', 1500 ,20),
	('C', 800 ,5),
	('D', 500, NULL);
	
SELECT product,
	(price - discount) AS net_price
FROM items;

SELECT product,
		(price - COALESCE(discount, 0)) AS net_price
FROM items;

SELECT product,
		(price - CASE 
		 WHEN discount IS NULL THEN 0
		 ELSE discount
		 END) AS net_price
FROM items;

-- ISNULL

--NULLIF

SELECT 
	NULLIF(1,1);
	
SELECT
	NULLIF(1,0);
	
SELECT
	NULLIF('A', 'B');
	
CREATE TABLE posts(
	id SERIAL PRIMARY KEY,
	title VARCHAR(255) NOT NULL,
	excerpt VARCHAR(150),
	body TEXT,
	created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	updated_at TIMESTAMP
);

INSERT INTO posts(title, excerpt, body)
VALUES  ('test post 1','test post excerpt 1','test post body 1'),
      ('test post 2','','test post body 2'),
      ('test post 3', null ,'test post body 3');
	  
SELECT id, title, excerpt, body
FROM posts;

SELECT id, title, body,
		COALESCE(excerpt, LEFT(body, 40)) AS excerpt_coal
FROM posts;

SELECT id, title, excerpt, body,
	COALESCE(
		NULLIF(excerpt, ''), LEFT(body, 40)) AS excerpt_coal
FROM posts;
	
CREATE TABLE members(
	id SERIAL PRIMARY KEY,
	first_name VARCHAR(50) NOT NULL,
	last_name VARCHAR(50) NOT NULL,
	gender SMALLINT NOT NULL
);

INSERT INTO members(first_name, last_name, gender)
VALUES('John', 'Doe', 1),
	('David', 'Dave', 1),
	('Bush', 'Lily', 2);
	
SELECT 
	(SUM(CASE 
	   	WHEN gender = 1 
	   	THEN 1
	   	ELSE 0
	END)/ SUM(CASE
			  WHEN gender = 2 THEN 1
			  ELSE 0
		  END)
	) * 100 AS "Male/Female ratio"
	
FROM members;

DELETE FROM members
WHERE gender = 2;

SELECT
	(SUM(
	 	 CASE WHEN gender = 1 THEN 1
		 ELSE 0
	 END)/ NULLIF(
	 			  SUM(
				  	  CASE WHEN gender = 2 THEN 1
				  	  ELSE 0
				   END), 0)) * 100 AS "Male/Female ratio"
FROM members;

--CAST To Convert a Value of One Type to Another

SELECT 
	'100' :: INTEGER,
	'01-OCT-2015' :: DATE;
SELECT
	CAST('10C' AS INTEGER);
	
SELECT
	CAST('2015-01-01' AS DATE),
	CAST('01-OCT-2015' AS DATE);
	
SELECT 
	CAST('10.2' AS DOUBLE PRECISION);
	
SELECT
	CAST('true' AS BOOLEAN),
	CAST('false' AS BOOLEAN),
	CAST('T' AS BOOLEAN),
	CAST('F' AS BOOLEAN);
	
SELECT '2019-06-15 14:30:20' :: TIMESTAMP;

SELECT '15 minute':: INTERVAL,
	'2 hour' :: INTERVAL,
	'1 day' :: INTERVAL,
	'2 week' :: INTERVAL,
	'3 month' :: INTERVAL;
	
CREATE TABLE ratings(
	id SERIAL PRIMARY KEY,
	rating VARCHAR(1) NOT NULL
);

INSERT INTO ratings(rating)
VALUES('A'),
	('B'),
	('C');
	
INSERT INTO ratings(rating)
VALUES (1),
	(2),
	(3);
	
SELECT * FROM ratings;

SELECT id,
		CASE
			WHEN rating~E'^\\d+$' THEN
					CAST(rating AS INTEGER)
			ELSE 0
			END AS rating
FROM ratings;