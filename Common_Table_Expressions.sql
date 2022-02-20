-- Common Table Expressions

WITH film_cte AS( 
	SELECT film_id, title,
			(CASE WHEN length < 30 THEN 'Short'
				 WHEN length < 90 THEN 'Medium'
				 ELSE 'Large' END) length
	FROM film
)

SELECT film_id, title, length
FROM film_cte
WHERE length = 'Large'
ORDER BY film_id;

WITH cte_rental AS(
	SELECT staff_id, COUNT(rental_id) rental_count
	FROM rental
	GROUP BY staff_id
)
SELECT s.staff_id, first_name, last_name, rental_count
FROM staff s INNER JOIN cte_rental c  USING(staff_id);

WITH cte_film AS(
	SELECT film_id,title,rating,length,
			RANK() OVER(PARTITION BY rating 
					    ORDER BY length DESC) length_rank
	FROM film
)
SELECT * FROM cte_film
WHERE length_rank = 1;