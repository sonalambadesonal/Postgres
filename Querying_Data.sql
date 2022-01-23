SELECT first_name FROM customer;
SELECT first_name,last_name,email FROM customer;
SELECT * FROM customer;
SELECT count(*) FROM customer;
SELECT first_name || ' ' || last_name as full_name, email FROM customer;
SELECT 4*3;

CREATE TABLE sort_demo(num INT);
INSERT INTO sort_demo(num) VALUES (1),(2),(3),(null);

SELECT num FROM sort_demo ORDER BY num;

SELECT num FROM sort_demo ORDER BY num NULLS FIRST;

SELECT num FROM sort_demo ORDER BY num DESC;

SELECT num FROM sort_demo ORDER BY num DESC NULLS LAST;

CREATE TABLE distinct_demo(id serial NOT NULL PRIMARY KEY,
						  bcolor VARCHAR,
						  fcolor VARCHAR);

INSERT INTO distinct_demo(bcolor, fcolor)
VALUES ('red', 'red'),
('red', 'red'),
('red', NULL),
(NULL, 'red'),
('red', 'green'),
('red', 'blue'),
('green', 'red'),
('green', 'blue'),
('green', 'green'),
('blue', 'red'),
('blue', 'green'),
('blue', 'blue');

SELECT id, bcolor, fcolor FROM distinct_demo;

SELECT * FROM distinct_demo;

SELECT DISTINCT bcolor FROM distinct_demo ORDER BY bcolor;

SELECT DISTINCT bcolor,fcolor FROM distinct_demo ORDER BY bcolor, fcolor;

SELECT DISTINCT ON (bcolor) bcolor, fcolor FROM distinct_demo ORDER BY bcolor, fcolor;



