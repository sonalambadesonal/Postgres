-- Joining Multiple Tables

-- JOINS
CREATE TABLE basket_a (
    a INT PRIMARY KEY,
	fruit_a VARCHAR (100) NOT NULL
);

CREATE TABLE basket_b (
    b INT PRIMARY KEY,
	fruit_b VARCHAR (100) NOT NULL
);

INSERT INTO basket_a (a, fruit_a) 
VALUES (1, 'Apple'),
(2, 'Orange'),
(3, 'Banana'),
(4, 'Cucumber');

INSERT INTO basket_b (b, fruit_b)
VALUES (1, 'Orange'),
(2, 'Apple'),
(3, 'Watermelon'),
(4, 'Pear');

SELECT * FROM basket_a;
SELECT * FROM basket_b;

SELECT a,fruit_a, b, fruit_b FROM basket_a INNER JOIN basket_b ON fruit_a = fruit_b;
SELECT a, fruit_a, b, fruit_b FROM basket_a LEFT JOIN basket_b ON fruit_a = fruit_b;
SELECT a, fruit_a, b, fruit_b FROM basket_a LEFT OUTER JOIN basket_b ON fruit_a = fruit_b;
SELECT a, fruit_a, b, fruit_b FROM basket_a LEFT JOIN basket_b ON fruit_a = fruit_b WHERE b IS NULL;

SELECT a, fruit_a, b, fruit_b FROM basket_a RIGHT JOIN basket_b ON fruit_a = fruit_b;
SELECT a, fruit_a, b, fruit_b FROM basket_a RIGHT JOIN basket_b ON fruit_a = fruit_b WHERE a IS NULL;

SELECT a, fruit_a, b, fruit_b FROM basket_a FULL OUTER JOIN basket_b ON fruit_a = fruit_b;
SELECT a, fruit_a, b, fruit_b FROM basket_a FULL JOIN basket_b ON fruit_a = fruit_b WHERE a IS NULL OR b IS NULL;

-- Aliases IN JOIN clause

SELECT c.customer_id, first_name, last_name, amount, payment_date 
FROM customer c INNER JOIN payment p ON c.customer_id = p.customer_id 
ORDER BY payment_date DESC;

SELECT e.first_name employee, m.first_name manager FROM staff e INNER JOIN staff m ON e.staff_id = m.staff_id;

-- INNER JOIN Clause

SELECT customer.customer_id, first_name, last_name, amount, payment_date
FROM customer INNER JOIN payment ON customer.customer_id = payment.customer_id
ORDER BY payment_date;

SELECT
	customer.customer_id,
	first_name,
	last_name,
	amount,
	payment_date
FROM
	customer
INNER JOIN payment 
    ON payment.customer_id = customer.customer_id
WHERE first_name = 'Joyce' AND payment_date = CAST('2007-02-14 21:21:59.996577' AS timestamp without time zone)   
ORDER BY payment_date;

SELECT c.customer_id, first_name, last_name, amount, payment_date
FROM customer c INNER JOIN payment p ON c.customer_id = p.customer_id
WHERE c.customer_id = 2;

SELECT customer.customer_id, first_name, last_name, amount, payment_date
FROM customer INNER JOIN payment USING(customer_id)
ORDER BY payment_date;

SELECT c.customer_id, c.first_name customer_first_name, c.last_name customer_last_name, s.first_name staff_first_name,
s.last_name staff_last_name, amount, payment_date
FROM customer c INNER JOIN payment p ON c.customer_id = p.customer_id INNER JOIN staff s ON s.staff_id = p.staff_id
ORDER BY payment_date;

SELECT c.customer_id, c.first_name customer_first_name, c.last_name customer_last_name, s.first_name staff_first_name,
s.last_name staff_last_name, amount, payment_date, st.last_update
FROM customer c INNER JOIN payment p ON c.customer_id = p.customer_id INNER JOIN staff s ON s.staff_id = p.staff_id INNER JOIN store st ON c.store_id = st.store_id 
ORDER BY payment_date;

SELECT c.customer_id, c.first_name customer_first_name, c.last_name customer_last_name, s.first_name staff_first_name, amount, payment_date, st.last_update
FROM customer c INNER JOIN payment p ON c.customer_id = p.customer_id INNER JOIN staff s ON s.staff_id = p.staff_id INNER JOIN store st ON c.store_id = st.store_id
WHERE c.customer_id = 416;

SELECT p.customer_id, first_name staff_first_name, amount, payment_date
FROM payment p INNER JOIN staff s ON s.staff_id = p.staff_id
WHERE p.customer_id = 416;

-- LEFT JOIN Clause

SELECT  f.film_id, title, i.inventory_id
FROM film f LEFT JOIN inventory i ON f.film_id = i.film_id
ORDER BY title;

SELECT f.film_id, title, inventory_id, i.film_id
FROM film f LEFT JOIN inventory i ON f.film_id = i.film_id
WHERE i.film_id IS NULL
ORDER BY title;

SELECT f.film_id, title, inventory_id
FROM film f LEFT JOIN inventory i USING(film_id)
WHERE i.film_id IS NULL
ORDER BY title;


-- RIGHT JOIN

DROP TABLE IF EXISTS films;
DROP TABLE IF EXISTS film_reviews;

CREATE TABLE films(
 film_id SERIAL PRIMARY KEY,
	title varchar(255) NOT NULL
);

INSERT INTO films(title)
VALUES('Joker'),
('Avengers: Endgame'),
('Parasite');

CREATE TABLE film_reviews(
review_id SERIAL PRIMARY KEY,
	film_id INT,
	review varchar(255) NOT NULL
);

INSERT INTO film_reviews(film_id, review)
VALUES(1, 'Excellent'),
(1, 'Awesome'),
(2, 'Cool'),
(NULL, 'Beautiful');

SELECT * FROM films;

SELECT * FROM film_reviews;

SELECT review, title
FROM films RIGHT JOIN film_reviews ON films.film_id = film_reviews.film_id;

SELECT review, title
FROM films RIGHT JOIN film_reviews USING(film_id);

SELECT review, title
FROM films RIGHT JOIN film_reviews USING(film_id)
WHERE title IS NULL;

--- SELF JOIN Clause

CREATE TABLE employee (
 employee_id INT PRIMARY KEY,
	first_name varchar(255) NOT NULL,
	last_name VARCHAR(255) NOT NULL,
	manager_id INT,
	FOREIGN KEY (manager_id)
	REFERENCES employee (employee_id)
	ON DELETE CASCADE
);

INSERT INTO employee(
 employee_id, first_name, last_name, manager_id
)
VALUES(1, 'Windy', 'Hays', NULL),
(2, 'Ava', 'Christensen', 1),
(3, 'Hassan', 'Conner', 1),
(4, 'Anna', 'Reeves', 2),
(5, 'Sau', 'Norman', 2),
(6, 'Kelsie', 'Hays', 3),
(7, 'Tory', 'Goff', 3),
(8, 'Salley', 'Lester', 3);

SELECT * FROM employee;

SELECT e.first_name ||' '|| e.last_name employee,
       m.first_name ||' '|| m.last_name manager
FROM employee e INNER JOIN employee m 
ON m.employee_id = e.manager_id
ORDER BY manager;


SELECT e.first_name ||' '|| e.last_name employee,
       m.first_name ||' '|| m.last_name manager
FROM employee e LEFT JOIN employee m ON m.employee_id = e.manager_id
ORDER BY manager;

SELECT e.first_name ||' '|| e.last_name employee,
       m.first_name ||' '|| m.last_name manager
FROM employee e RIGHT JOIN employee m ON m.employee_id = e.manager_id
ORDER BY manager;

SELECT f1.title,
	   f2.title,
	   f1.length
FROM film f1 INNER JOIN film f2 ON f1.film_id != f2.film_id AND f1.length = f2.length;


-- FULL OUTER JOIN Clause

DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS departments;

CREATE TABLE departments(
		department_id SERIAL PRIMARY KEY,
		department_name VARCHAR(255) NOT NULL
);

CREATE TABLE employees(
		employee_id SERIAL PRIMARY KEY,
		employee_name VARCHAR(255),
		department_id INT
);

INSERT INTO departments(department_name)
VALUES('Sales'),
('Marketing'),
('HR'),
('IT'),
('Production');

INSERT INTO employees(employee_name, department_id)
VALUES('Bette Nicholson', 1),
	('Christian Gable', 1),
	('Joe Swank', 2),
	('Fred Costner', 3),
	('Sandra Kilmer', 4),
	('Julia Mcqueen', NULL);
	
SELECT * FROM departments;
SELECT * FROM employees;

SELECT employee_name, department_name
FROM employees e FULL JOIN departments d ON e.department_id = d.department_id;

SELECT employee_name, department_name
FROM employees FULL JOIN departments USING(department_id);

SELECT employee_name, department_name
FROM employees FULL JOIN departments USING(department_id)
WHERE department_name IS NULL;

SELECT employee_name, department_name
FROM employees FULL JOIN departments USING(department_id)
WHERE employee_name IS NULL;

DROP TABLE IF EXISTS T1;
DROP TABLE IF EXISTS T2;

CREATE TABLE T1(label CHAR(1) PRIMARY KEY);

CREATE TABLE T2(score INT PRIMARY KEY);

INSERT INTO T1(label)
VALUES('A'),
	('B');
	
INSERT INTO T2(score)
VALUES(1),
(2),
(3);

SELECT label,score
FROM T1 CROSS JOIN T2;

SELECT label,score
FROM T1 INNER JOIN T2 ON true;
	
-- NATURAL JOIN Clause

DROP TABLE IF EXISTS categories;
CREATE TABLE categories (
	category_id serial PRIMARY KEY,
	category_name VARCHAR (255) NOT NULL
);

DROP TABLE IF EXISTS products;
CREATE TABLE products (
	product_id serial PRIMARY KEY,
	product_name VARCHAR (255) NOT NULL,
	category_id INT NOT NULL,
	FOREIGN KEY (category_id) REFERENCES categories (category_id)
);

INSERT INTO categories (category_name)
VALUES
	('Smart Phone'),
	('Laptop'),
	('Tablet');

INSERT INTO products (product_name, category_id)
VALUES
	('iPhone', 1),
	('Samsung Galaxy', 1),
	('HP Elite', 2),
	('Lenovo Thinkpad', 2),
	('iPad', 3),
	('Kindle Fire', 3);
	
SELECT * FROM categories NATURAL JOIN products;
SELECT * FROM categories c INNER JOIN products  p ON c.category_id = p.category_id;
SELECT * FROM categories  INNER JOIN products USING(category_id);
SELECT * 
FROM city
NATURAL JOIN country;

SELECT * 
FROM city
INNER JOIN country USING(country_id);

