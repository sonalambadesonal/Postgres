-- Grouping sets, Cube, and Rollup

-- Grouping Sets Clause

DROP TABLE IF EXISTS sales;
CREATE TABLE sales(
	brand VARCHAR NOT NULL,
	segment VARCHAR NOT NULL,
	quantity INT NOT NULL,
	PRIMARY KEY(brand,segment)
);

INSERT INTO sales(brand,segment,quantity)
VALUES('ABC', 'Premium', 100),
    ('ABC', 'Basic', 200),
    ('XYZ', 'Premium', 100),
    ('XYZ', 'Basic', 300);

SELECT brand, segment, SUM(quantity)
FROM sales
GROUP BY brand,segment;

SELECT brand, SUM(quantity)
FROM sales
GROUP BY brand;

SELECT segment, SUM(quantity)
FROM sales
GROUP BY segment;

SELECT SUM (quantity) FROM sales;

SELECT
    brand,
    segment,
    SUM (quantity)
FROM
    sales
GROUP BY
    brand,
    segment

UNION ALL

SELECT
    brand,
    NULL,
    SUM (quantity)
FROM
    sales
GROUP BY
    brand

UNION ALL

SELECT
    NULL,
    segment,
    SUM (quantity)
FROM
    sales
GROUP BY
    segment

UNION ALL

SELECT
    NULL,
    NULL,
    SUM (quantity)
FROM
    sales;

SELECT brand,segment, SUM(quantity) 
FROM sales
GROUP BY
	GROUPING SETS(
			(brand,segment),
			(brand),
			(segment),
			()
	);

SELECT GROUPING(brand) grouping_brand, GROUPING(segment) grouping_segment, brand, segment, SUM(quantity)
FROM sales
GROUP BY 
	GROUPING SETS(
		(brand,segment),
		(brand),
		(segment),
		()
	)
ORDER BY brand;

SELECT GROUPING(brand) grouping_brand, GROUPING(segment) grouping_segment, brand, segment, SUM(quantity)
FROM sales
GROUP BY
	GROUPING SETS(
		(brand,segment),
		(brand),
		(segment),
		()
	)
HAVING GROUPING(brand) = 0 AND GROUPING(segment) != 0
ORDER BY brand; 

-- ROLLUP Clause

SELECT brand, segment, SUM(quantity)
FROM sales
GROUP BY
	ROLLUP (brand, segment)
ORDER BY brand, segment;

SELECT segment, brand, SUM(quantity)
FROM sales
GROUP BY
	ROLLUP (segment, brand)
ORDER BY segment, brand;

SELECT segment, brand, SUM(quantity)
FROM sales
GROUP BY segment,
	ROLLUP (brand)
ORDER BY segment, brand;

-- rental_date = yyyy/mm/dd
SELECT EXTRACT(YEAR FROM rental_date) y,
	EXTRACT(MONTH FROM rental_date) m,
	EXTRACT(DAY FROM rental_date) d,
	COUNT(rental_id)
FROM rental
GROUP BY
	ROLLUP( EXTRACT(YEAR FROM rental_date),
	EXTRACT(MONTH FROM rental_date),
	EXTRACT(DAY FROM rental_date)
	);
	
-- CUBE Clause

SELECT brand, segment, SUM(quantity)
FROM sales
GROUP BY 
	CUBE (brand, segment)
ORDER BY brand, segment;

SELECT EXTRACT(YEAR FROM rental_date) y,
	EXTRACT(MONTH FROM rental_date) m,
	EXTRACT(DAY FROM rental_date) d,
	COUNT(rental_id)
FROM rental
GROUP BY
	CUBE( EXTRACT(YEAR FROM rental_date),
	EXTRACT(MONTH FROM rental_date),
	EXTRACT(DAY FROM rental_date)
	);
