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
