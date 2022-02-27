--Transactions

DROP TABLE IF EXISTS accounts;
CREATE TABLE accounts(
	id INT GENERATED BY DEFAULT AS IDENTITY,
	name VARCHAR(100) NOT NULL,
	balance DEC(15, 2) NOT NULL,
	PRIMARY KEY(id)
);

INSERT INTO accounts(name, balance)
VALUES('Bob',10000);

BEGIN;
INSERT INTO accounts(name, balance)
VALUES('Alice',10000);

SELECT * FROM accounts;

COMMIT;

BEGIN;
UPDATE accounts
SET balance = balance - 1000
WHERE id = 1;

UPDATE accounts
SET balance = balance + 1000
WHERE id = 2;

COMMIT;

INSERT INTO accounts(name, balance)
VALUES('Jack',0);

BEGIN;

UPDATE accounts
SET balance = balance - 1500
WHERE id = 1;

UPDATE accounts
SET balance = balance + 1500
WHERE id = 3;

ROLLBACK;