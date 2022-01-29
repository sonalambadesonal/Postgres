-- Filtering Data
-- WHERE clause
SELECT first_name, last_name FROM customer WHERE first_name = 'Jamie';
SELECT first_name, last_name FROM customer WHERE first_name = 'Jamie' AND last_name = 'Rice';
SELECT first_name, last_name FROM customer WHERE last_name = 'Rodriguez' OR first_name = 'Adam';
SELECT first_name, last_name FROM customer WHERE first_name IN ('Ann', 'Anna', 'Annie');
SELECT first_name, last_name FROM customer WHERE first_name IN ('Ann', 'Anna', 'Annie','Rodriguez') OR last_name IN ('Ann', 'Anna', 'Annie','Rodriguez');
SELECT first_name, last_name FROM customer WHERE first_name LIKE 'Ann%';
SELECT first_name, LENGTH(first_name) first_name_length FROM customer WHERE first_name LIKE 'A%' AND LENGTH(first_name) BETWEEN 3 AND 5 ORDER BY first_name_length;
SELECT first_name, last_name FROM customer WHERE first_name LIKE 'Bra%' AND last_name != 'Motley';
SELECT film_id, title, release_year FROM film WHERE film_id BETWEEN 4 AND 7 ORDER BY title;

-- LIMIT clause
SELECT film_id, title, release_year FROM film ORDER BY film_id LIMIT 5;
SELECT film_id, title, release_year FROM film ORDER BY film_id LIMIT 4 OFFSET 3; 
SELECT film_id, title, rental_rate FROM film ORDER BY rental_rate DESC LIMIT 10;
SELECT film_id, title, rental_rate, release_year FROM film ORDER BY release_year DESC LIMIT 50;

-- FETCH clause
SELECT film_id, title FROM film ORDER BY title FETCH  FIRST ROW ONLY;
SELECT film_id, title FROM film ORDER BY title FETCH FIRST 5 ROWS ONLY;
SELECT film_id, title FROM film ORDER BY title OFFSET 5 ROWS FETCH FIRST 5 ROWS ONLY;

-- IN operator
SELECT customer_id, rental_id, return_date FROM rental WHERE customer_id IN (1,2) ORDER BY return_date DESC;
SELECT customer_id, rental_id, return_date FROM rental WHERE customer_id = 1 OR customer_id = 2 ORDER BY return_date DESC;
SELECT customer_id, rental_id, return_date FROM rental WHERE customer_id NOT IN (1,2) ORDER BY customer_id;
SELECT customer_id, rental_id, return_date FROM rental WHERE customer_id != 1 AND customer_id != 2;
SELECT customer_id FROM rental WHERE CAST(return_date AS DATE) = '2005-05-27' ORDER BY customer_id;

SELECT customer_id, first_name, last_name 
FROM customer 
WHERE customer_id IN (SELECT customer_id 
					  FROM rental 
					  WHERE CAST(return_date AS DATE)= '2005-05-27') 
ORDER BY customer_id;

-- BETWEEN Operator

SELECT customer_id, payment_id, amount FROM payment WHERE amount BETWEEN 8 AND 9;
SELECT customer_id, payment_id, amount FROM payment WHERE amount NOT BETWEEN 8 AND 9;
SELECT customer_id, payment_id, amount, payment_date FROM payment WHERE payment_date BETWEEN '2007-02-07' AND '2007-02-15';
