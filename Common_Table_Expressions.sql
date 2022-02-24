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

-- Recursive CTEs

DROP TABLE IF EXISTS employees;
CREATE TABLE employees(
	employee_id SERIAL PRIMARY KEY,
	full_name VARCHAR NOT NULL,
	manager_id INT
);

INSERT INTO employees(employee_id, full_name, manager_id)
VALUES (1, 'Michael North', NULL),
	(2, 'Megan Berry', 1),
	(3, 'Sarah Berry', 1),
	(4, 'Zoe Black', 1),
	(5, 'Tim James', 1),
	(6, 'Bella Tucker', 2),
	(7, 'Ryan Metcalfe', 2),
	(8, 'Max Mills', 2),
	(9, 'Benjamin Glover', 2),
	(10, 'Carolyn Henderson', 3),
	(11, 'Nicola Kelly', 3),
	(12, 'Alexandra Climo', 3),
	(13, 'Dominic King', 3),
	(14, 'Leonard Gray', 4),
	(15, 'Eric Rampling', 4),
	(16, 'Piers Paige', 7),
	(17, 'Ryan Henderson', 7),
	(18, 'Frank Tucker', 8),
	(19, 'Nathan Ferguson', 8),
	(20, 'Kevin Rampling', 8);
	
WITH RECURSIVE subordinates  AS(
	SELECT employee_id, manager_id, full_name
	FROM employees
	WHERE employee_id = 2
	
	UNION
	SELECT e.employee_id , e.manager_id , e.full_name 
	FROM subordinates s INNER JOIN employees e ON s.employee_id = e.manager_id
	
)SELECT * FROM subordinates;
	