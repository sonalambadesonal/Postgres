--  Modifying Data
DROP TABLE IF EXISTS links;

CREATE TABLE links(
	id SERIAL PRIMARY KEY,
	url VARCHAR(255) NOT NULL,
	name VARCHAR(255) NOT NULL,
	description VARCHAR(255),
	last_update DATE
);

INSERT INTO links(url, name) 
VALUES('https://www.postgresqltutorial.com','PostgreSQL Tutorial');
SELECT * FROM links;

INSERT INTO links(url, name)
VALUES('http://www.oreilly.com','O''Reilly Media');

INSERT INTO links(url, name, last_update)
VALUES('https://www.google.com','Google','2013-06-01');

INSERT INTO links(url, name)
VALUES('http://www.postgresql.org','PostgreSQL')
RETURNING id;

INSERT INTO links(url, name)
VALUES('http://www.facebook.com', 'Facebook'),
	('https://www.twitter.com', 'Twitter'),
	('https://www.instagram.com', 'Instagram');

INSERT INTO links(url, name)
VALUES('https://www.twitter.com', 'Twitter'),
	('https://www.instagram.com', 'Instagram')
RETURNING *;

INSERT INTO links(url, name, description)
VALUES ('https://www.searchencrypt.com/','SearchEncrypt','Search Encrypt'),
    ('https://www.startpage.com/','Startpage','The world''s most private search engine')
RETURNING id;

-- UPDATE 

DROP TABLE IF EXISTS courses;
CREATE TABLE courses(
	course_id SERIAL PRIMARY KEY,
	course_name VARCHAR(255) NOT NULL,
	description VARCHAR(500),
	published_date DATE
);

INSERT INTO courses(course_name, description, published_date)
VALUES('PostgreSQL for Developers','A complete PostgreSQL for Developers','2020-07-13'),
	('PostgreSQL Admininstration','A PostgreSQL Guide for DBA',NULL),
	('PostgreSQL High Performance',NULL,NULL),
	('PostgreSQL Bootcamp','Learn PostgreSQL via Bootcamp','2013-07-11'),
	('Mastering PostgreSQL','Mastering PostgreSQL in 21 Days','2012-06-30');
SELECT * FROM courses;

UPDATE courses
SET published_date = '2020-03-21'
WHERE course_id = 3;

SELECT * FROM courses WHERE course_id = 3;

UPDATE courses
SET published_date = '2020-12-24'
WHERE course_id = 2
RETURNING *;

-- UPDATE JOIN

DROP TABLE IF EXISTS product_segment;
CREATE TABLE product_segment(
	id SERIAL PRIMARY KEY,
	segment VARCHAR NOT NULL,
	discount NUMERIC (4,2)
);

INSERT INTO product_segment(segment, discount)
VALUES ('Grand Luxury', 0.05),
    ('Luxury', 0.06),
    ('Mass', 0.1);
	
DROP TABLE IF EXISTS product;
CREATE TABLE product(
	id SERIAL PRIMARY KEY,
	name VARCHAR NOT NULL,
	price NUMERIC (10,2),
	net_price NUMERIC (10,2),
	segment_id INT NOT NULL,
	FOREIGN KEY(segment_id) REFERENCES product_segment(id)
);

INSERT INTO product(name, price, segment_id)
VALUES ('diam', 804.89, 1),
    ('vestibulum aliquet', 228.55, 3),
    ('lacinia erat', 366.45, 2),
    ('scelerisque quam turpis', 145.33, 3),
    ('justo lacinia', 551.77, 2),
    ('ultrices mattis odio', 261.58, 3),
    ('hendrerit', 519.62, 2),
    ('in hac habitasse', 843.31, 1),
    ('orci eget orci', 254.18, 3),
    ('pellentesque', 427.78, 2),
    ('sit amet nunc', 936.29, 1),
    ('sed vestibulum', 910.34, 1),
    ('turpis eget', 208.33, 3),
    ('cursus vestibulum', 985.45, 1),
    ('orci nullam', 841.26, 1),
    ('est quam pharetra', 896.38, 1),
    ('posuere', 575.74, 2),
    ('ligula', 530.64, 2),
    ('convallis', 892.43, 1),
    ('nulla elit ac', 161.71, 3);
	
SELECT * FROM product;
SELECT * FROM product_segment;

UPDATE product p
SET net_price = price - price * discount
FROM product_segment ps
WHERE ps.id = p.segment_id;

-- DELETE

DROP TABLE IF EXISTS links;
CREATE TABLE links(
	id SERIAL PRIMARY KEY,
    url VARCHAR(255) NOT NULL,
    name VARCHAR(255) NOT NULL,
    description VARCHAR(255),
    rel VARCHAR(10),
    last_update DATE DEFAULT now()
);
SELECT * FROM links;

INSERT INTO links
VALUES
	  ('2', 'https://www.postgresqltutorial.com', 'PostgreSQL Tutorial', 'Learn PostgreSQL fast and easy', 'follow', '2013-06-02'),
   ('3', 'http://www.oreilly.com', 'O''Reilly Media', 'O''Reilly Media', 'nofollow', '2013-06-02'),
   ('4', 'http://www.google.com', 'Google', 'Google', 'nofollow', '2013-06-02'),
   ('5', 'http://www.yahoo.com', 'Yahoo', 'Yahoo', 'nofollow', '2013-06-02'),
   ('6', 'http://www.bing.com', 'Bing', 'Bing', 'nofollow', '2013-06-02'),
   ('7', 'http://www.facebook.com', 'Facebook', 'Facebook', 'nofollow', '2013-06-01'),
   ('8', 'https://www.tumblr.com/', 'Tumblr', 'Tumblr', 'nofollow', '2013-06-02'),
   ('9', 'http://www.postgresql.org', 'PostgreSQL', 'PostgreSQL', 'nofollow', '2013-06-02');
   
DELETE FROM links
WHERE id = '1';

DELETE FROM links
WHERE id = '10';

DELETE FROM links
WHERE id = '7'
RETURNING *;

DELETE FROM links
WHERE id IN (6,5)
RETURNING *;

DELETE FROM links;


	