-- Grouping Data

-- GROUP BY

SELECT customer_id
FROM payment
GROUP BY customer_id;

SELECT * FROM payment;

SELECT customer_id, SUM(amount)
FROM payment
GROUP BY customer_id;

SELECT customer_id, SUM(amount)
FROM payment
GROUP BY customer_id
ORDER BY SUM(amount) DESC;

SELECT customer_id, SUM(amount)
FROM payment
GROUP BY customer_id
ORDER BY SUM(amount);

SELECT first_name ||' '|| last_name full_name, SUM(amount) amount
FROM payment INNER JOIN customer USING(customer_id)
GROUP BY full_name
ORDER BY SUM(amount) DESC;

SELECT first_name ||' '|| last_name full_name,customer_id, SUM(amount) amount
FROM payment INNER JOIN customer  USING(customer_id)
GROUP BY customer_id
ORDER BY SUM(amount) DESC;

SELECT staff_id, COUNT(payment_id)
FROM payment
GROUP BY staff_id;

SELECT staff_id, customer_id, SUM(amount)
FROM payment
GROUP BY customer_id, staff_id;

SELECT staff_id, customer_id, COUNT(payment_id)
FROM payment
GROUP BY customer_id, staff_id;

SELECT DATE(payment_date) paid_date, SUM(amount)
FROM payment
GROUP BY DATE(payment_date);

SELECT DATE(payment_date), customer_id, SUM(amount)
FROM payment
WHERE customer_id = 1
GROUP BY customer_id, DATE(payment_date)
ORDER BY DATE(payment_date);

SELECT store_id, COUNT(customer_id)
FROM customer
GROUP BY store_id;

-- HAVING Clause

SELECT customer_id, SUM(amount)
FROM payment
GROUP BY customer_id
HAVING SUM(amount) > 200;

SELECT customer_id, SUM(amount)
FROM payment
GROUP BY customer_id
HAVING SUM(amount) < 50;

SELECT customer_id, SUM(amount)
FROM payment
GROUP BY customer_id
HAVING SUM(amount) > 50 AND SUM(amount) < 200;

SELECT store_id, COUNT(customer_id)
FROM customer
GROUP BY store_id
HAVING COUNT(customer_id) > 300;

