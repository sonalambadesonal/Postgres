--  Subquery

SELECT film_id, title, rental_rate
FROM film
WHERE rental_rate > (
	SELECT AVG(rental_rate)
	FROM film
);


SELECT inv.film_id
FROM rental re INNER JOIN inventory inv ON inv.inventory_id = re.inventory_id
WHERE return_date BETWEEN '2005-05-29' AND '2005-05-30';

SELECT film_id, title

FROM film

WHERE film_id  IN(
			SELECT inv.film_id
           FROM rental re INNER JOIN inventory inv ON inv.inventory_id = re.inventory_id
            WHERE return_date BETWEEN '2005-05-29' AND '2005-05-30'

);

SELECT 1, first_name, last_name
FROM customer INNER JOIN payment USING(customer_id);

SELECT first_name, last_name
FROM customer
WHERE EXISTS( SELECT 1 FROM payment WHERE payment.customer_id = customer.customer_id );

-- ANY Operator

SELECT MAX(length), category_id
FROM film INNER JOIN film_category USING(film_id)
GROUP BY category_id
ORDER BY MAX(length);

SELECT title,length
FROM film
WHERE length >= ANY(SELECT MAX(length)
FROM film INNER JOIN film_category USING(film_id)
GROUP BY category_id
ORDER BY category_id)
ORDER BY length;

SELECT title, category_id
FROM film INNER JOIN film_category USING(film_id)
WHERE category_id = ANY(SELECT category_id FROM category WHERE name = 'Drama' OR name = 'Action');


SELECT * FROM category;

-- ALL Operator

SELECT COUNT(length), rating
FROM film
GROUP BY rating
ORDER BY COUNT(length);

SELECT ROUND(AVG(length), 2) avg_length
FROM film
GROUP BY rating
ORDER BY avg_length DESC;

SELECT film_id, title, length
FROM film
WHERE length > ALL(SELECT ROUND(AVG(length), 2) avg_length
FROM film
GROUP BY rating)
ORDER BY length;

SELECT film_id, title, length
FROM film
WHERE length < ALL(SELECT ROUND(AVG(length), 3) avg_length FROM film GROUP BY rating);

-- EXSITS Operator

SELECT 1, customer.customer_id,amount
FROM customer  INNER JOIN payment  USING(customer_id)
WHERE amount > 11;

SELECT first_name, last_name
FROM customer c
WHERE EXISTS(SELECT 1 FROM payment p WHERE c.customer_id = p.customer_id AND p.amount>11);

SELECT first_name, last_name
FROM customer c
WHERE NOT EXISTS(SELECT 1 FROM payment p WHERE c.customer_id = p.customer_id AND amount > 11);

SELECT first_name, last_name
FROM customer c
WHERE EXISTS(SELECT 1 FROM payment p WHERE c.customer_id = p.customer_id AND amount < 11);

SELECT first_name, last_name
FROM customer
WHERE EXISTS(SELECT NULL);



