--Indexes
--Create Index

SELECT * FROM address
WHERE phone = '223664661973';

EXPLAIN SELECT * FROM address
WHERE phone = '223664661973';

CREATE INDEX idx_address_phone
ON address(phone);

CREATE INDEX idx_actor_first_name
ON actor(first_name);

--DROP INDEX

SELECT * FROM actor
WHERE first_name = 'John';

EXPLAIN SELECT * FROM actor
WHERE first_name = 'John';

DROP INDEX idx_actor_first_name;

-- LIST INDEX

SELECT indexname, indexdef
FROM pg_indexes
WHERE tablename = 'customer';

SELECT tablename, indexname, indexdef
FROM pg_indexes
WHERE tablename LIKE 'c%'
ORDER BY tablename, indexname;

