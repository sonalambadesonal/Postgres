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



