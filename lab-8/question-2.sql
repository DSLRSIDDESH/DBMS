DROP TABLE bank;
DROP TABLE account_holder;

CREATE TABLE bank(bank_name varchar(10), state varchar(20));

INSERT INTO bank VALUES('SBI','ANDHRA PRADESH');
INSERT INTO bank VALUES('SBI','TAMILNADU');
INSERT INTO bank VALUES('SBI','KARNATAKA');
INSERT INTO bank VALUES('ICICI','TAMILNADU');
INSERT INTO bank VALUES('ICICI','KARNATAKA');

CREATE TABLE account_holder(account_name varchar(15), bank_name varchar(10), state_name varchar(20));

INSERT INTO account_holder VALUES('RAMESH','ICICI','TAMILNADU');
INSERT INTO account_holder VALUES('DINESH','SBI','ANDHRA PRADESH');
INSERT INTO account_holder VALUES('ROBERT','SBI','TAMILNADU');
INSERT INTO account_holder VALUES('ROBERT','ICICI','KARNATAKA');
INSERT INTO account_holder VALUES('ROBERT','SBI','ANDHRA PRADESH');
INSERT INTO account_holder VALUES('KARTHIK','SBI','ANDHRA PRADESH');

-- 3.a. Find the ACCOUNT_NAME having account in all banks.

SELECT distinct(account_name) FROM account_holder 
MINUS SELECT distinct(account_name)  FROM 
(SELECT * FROM (SELECT distinct(account_name) FROM account_holder),
(SELECT distinct(bank_name) FROM bank)
MINUS SELECT account_name, bank_name FROM account_holder);

-- 3.b. Find the bank available in all the state.

SELECT distinct(bank_name) FROM bank
MINUS SELECT distinct(bank_name) FROM 
(SELECT * FROM (SELECT bank_name from bank),
(SELECT state FROM bank) MINUS
SELECT bank_name, state FROM bank);

-- 3.c. Find the bank not available in all the state.

SELECT distinct(bank_name) FROM 
(SELECT * FROM (SELECT bank_name from bank),
(SELECT state FROM bank) MINUS
SELECT bank_name, state FROM bank);

-- 3.d. Find the ACCOUNT_NAME having account in all the state

SELECT distinct(account_name) FROM account_holder 
MINUS SELECT distinct(account_name)  FROM 
(SELECT * FROM (SELECT distinct(account_name) FROM account_holder),
(SELECT distinct(state) FROM bank)
MINUS SELECT account_name, state_name FROM account_holder);