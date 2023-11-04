-- Tábla létrehozása
CREATE TABLE bank_account (
    id SERIAL PRIMARY KEY,
    balance DECIMAL NOT NULL
);

-- Kezdeti egyenleg beállítása
INSERT INTO bank_account (balance) VALUES (1000);

Hibás:

-- Első tranzakció
BEGIN TRANSACTION ISOLATION LEVEL READ COMMITTED;
UPDATE bank_account SET balance = balance*3 WHERE id = 1;

-- Második tranzakció egy másik sessionben/query ablakban
BEGIN TRANSACTION ISOLATION LEVEL READ COMMITTED ;
UPDATE bank_account SET balance = balance /2 WHERE id = 1;

-- Visszatérés az első tranzakcióhoz
    UPDATE bank_account SET balance = balance*3  WHERE id = 1;
    COMMIT;

-- Második tranzakció egy másik sessionben/query ablakban
    COMMIT;



Serializable
-- Első tranzakció
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
UPDATE bank_account SET balance = balance *3 WHERE id = 1;

-- Második tranzakció egy másik sessionben/query ablakban
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
UPDATE bank_account SET balance = balance/2 WHERE id = 1;


-- Visszatérés az első tranzakcióhoz
    COMMIT;

második tranzakciónál error:
ERROR:  could not serialize access due to concurrent update


