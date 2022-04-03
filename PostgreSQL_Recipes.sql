--PostgreSQL Recipes

--Compare Two Tables in PostgreSQL

CREATE TABLE foo(
	id INT PRIMARY KEY,
	name VARCHAR(50)
);

INSERT INTO foo(id,name)
VALUES(1, 'a'),
	(2, 'b');
	
CREATE TABLE bar(
	id INT PRIMARY KEY,
	name VARCHAR(50)
);

INSERT INTO bar(id, name)
VALUES(1, 'a'),
	(2, 'b');
	
UPDATE bar
SET name = 'c'
WHERE id = 2;

SELECT id, name, 'not in bar' AS note
FROM foo
EXCEPT
	SELECT id,name,'not in bar' AS note
	FROM bar 
UNION	
SELECT id,name, 'not in foo' AS note
FROM bar
EXCEPT
	SELECT id,name, 'not in foo' AS note
	FROM foo;
	
SELECT id,name
FROM foo
FULL OUTER JOIN bar USING(id, name)
WHERE foo.id IS NULL OR
bar.id IS NULL;

SELECT COUNT(*)
FROM foo
FULL OUTER JOIN bar USING(id, name)
WHERE foo.id IS NULL OR bar.id IS NULL;

--How To Delete Duplicate Rows 

CREATE TABLE basket(
	id SERIAL PRIMARY KEY,
	fruit VARCHAR(50) NOT NULL
);

DROP TABLE IF EXISTS basket;

INSERT INTO basket(fruit) VALUES('apple');
INSERT INTO basket(fruit) VALUES('apple');

INSERT INTO basket(fruit) VALUES('orange');
INSERT INTO basket(fruit) VALUES('orange');
INSERT INTO basket(fruit) VALUES('orange');

INSERT INTO basket(fruit) VALUES('banana');

SELECT * FROM basket;

SELECT fruit, COUNT(fruit)
FROM basket
GROUP BY fruit
HAVING COUNT(fruit) > 1
ORDER BY fruit;

DELETE FROM basket a USING basket b
WHERE a.id < b.id AND a.fruit = b.fruit;

SELECT id , ROW_NUMBER() OVER(PARTITION BY fruit
							 ORDER BY id) AS row_num
FROM basket;

--
1	1
2	2
6	1
3	1
4	2
5	3

--
SELECT id 
FROM(SELECT id , ROW_NUMBER() OVER(PARTITION BY fruit
							 ORDER BY id) AS row_num
FROM basket) t
WHERE t.row_num > 1;

DELETE FROM basket
WHERE id IN
(SELECT id 
FROM(SELECT id , ROW_NUMBER() OVER(PARTITION BY fruit
							 ORDER BY id) AS row_num
FROM basket) t
WHERE t.row_num > 1);

DELETE FROM basket
WHERE id IN
(SELECT id 
FROM(SELECT id , ROW_NUMBER() OVER(PARTITION BY fruit
							 ORDER BY id DESC) AS row_num
FROM basket) t
WHERE t.row_num > 1);

CREATE TABLE basket_temp(LIKE basket);

SELECT * FROM basket_temp;

INSERT INTO basket_temp(fruit, id)
SELECT 
	DISTINCT ON (fruit) fruit,
	id
FROM basket;

DROP TABLE basket;

ALTER TABLE basket_temp
RENAME TO basket;

--How to Generate a Random Number in a Range
SELECT random();

SELECT random()* 10 + 1 AS rand_1_11;

SELECT floor(random()*10+1)::int;

SELECT floor(9.9);

CREATE OR REPLACE FUNCTION random_between(low INT, high INT)
RETURNS INT AS
$$
BEGIN
	RETURN floor(random()*(high-low+1) +low);
END;
$$ language 'plpgsql' STRICT;

SELECT random_between(10, 12);

SELECT random_between(1,10)
FROM generate_series(1,5);

--PostgreSQL EXPLAIN

EXPLAIN SELECT * FROM film;

EXPLAIN SELECT * FROM film WHERE film_id = 100;

EXPLAIN (FORMAT YAML) SELECT * 
FROM film
WHERE film_id = 100;

EXPLAIN(FORMAT JSON) SELECT COUNT(*) FROM film;

EXPLAIN
SELECT f.film_id, title, name category_name
FROM film f 
	INNER JOIN film_category fc ON fc.film_id = f.film_id
	INNER JOIN category c ON c.category_id = fc.category_id
ORDER BY title;
