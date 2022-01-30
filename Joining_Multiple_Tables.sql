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