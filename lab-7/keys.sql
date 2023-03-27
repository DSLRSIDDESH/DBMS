SET linesize 1000;
SET pagesize 1000;

DROP TABLE orders;
DROP TABLE agent;
DROP TABLE employees;
DROP TABLE salesman;
DROP TABLE orders2;
DROP TABLE temp_agent;

ALTER TABLE orders DROP FOREIGN key fk_agent;
ALTER TABLE orders2 DROP FOREIGN key fk_salesman;

-- Question-1

CREATE TABLE orders(ord_num VARCHAR(3), ord_amount NUMBER(10), advance_amount NUMBER(10), ord_date VARCHAR(15), cust_code VARCHAR(5), agent_code VARCHAR(6), description VARCHAR(30));
INSERT INTO orders VALUES('004', 200, 3000, '15-aug-2020', 'C004', 'Ac001', 'Masala Kulcha');
INSERT INTO orders VALUES('007', 600, 5000, '17-sept-2020', 'C006', 'Ac003', 'Biriyani');
INSERT INTO orders VALUES('008', 700, 100, '19-feb-2019', 'C007', 'Ac005', NULL);
INSERT INTO orders VALUES('009', 10000, 600, '21-march-2010', 'C009', 'Ac004', 'Masala dosa');
INSERT INTO orders VALUES('010', 20, 600, '21-april-2012', 'C006', 'Ac002', NULL);

CREATE TABLE agent(agent_code VARCHAR(6), agent_name VARCHAR(20), working_area VARCHAR(20), commission NUMBER(3,2), phone_no VARCHAR(10), country VARCHAR(20));
INSERT INTO agent VALUES('Ac001', 'Ramesh', 'Bangalore', 0.15, '0331234567', 'India');
INSERT INTO agent VALUES('Ac002', 'Dinesh', 'Bangalore', 0.25, '0331234568', 'India');
INSERT INTO agent VALUES('Ac003', 'Suresh', 'Mumbai', 0.35, '0331234569', 'London');
INSERT INTO agent VALUES('Ac004', 'Kamlesh', 'Ney Jersey', 0.68, '0331234564', 'London');
INSERT INTO agent VALUES('Ac005', 'Kartik', 'Chennai', 0.73, '0331234563', 'India');

ALTER TABLE agent ADD CONSTRAINT pk_agent PRIMARY KEY (agent_code);
ALTER TABLE orders ADD CONSTRAINT fk_agent FOREIGN KEY (agent_code) REFERENCES agent(agent_code);

-- 1.a. Find ord_num, ord_amount, ord_date, cust_code and agent_code lives in same country or
-- working area is same.
-- 1.a.
SELECT ord_num,ord_amount,ord_date,cust_code,orders.agent_code FROM orders WHERE 
agent_code IN (SELECT a1.agent_code FROM agent a1, agent a2 WHERE 
(a1.country = a2.country AND a1.agent_code != a2.agent_code) 
OR (a1.working_area = a2.working_area AND a1.agent_code != a2.agent_code));

-- 1.b. Retrive ord_num, ord_amount, cust_code and agent_code from the table orders where the
-- agent_code of orders table must be the same agent_code of agents table and agent_name of
-- agents table have atleast one 'a' having different working_area.
-- 1.b.
CREATE TABLE temp_agent AS
SELECT working_area,count(working_area) as count from agent GROUP BY working_area;
SELECT ord_num, ord_amount, cust_code, agent_code FROM orders WHERE 
agent_code IN (SELECT agent_code FROM agent JOIN temp_agent ON 
agent.working_area = temp_agent.working_area AND temp_agent.count = 1 WHERE 
agent_name LIKE '%a%');

-- Question-2

CREATE TABLE employees(employee_id VARCHAR(3), first_name VARCHAR(20), last_name VARCHAR(20), email VARCHAR(40), phone_number VARCHAR(10), hire_date DATE, job_id VARCHAR(6), salary NUMBER(10), manager_id VARCHAR(4), department_id VARCHAR(2));
INSERT INTO employees VALUES('700', 'Hasmukh', 'Patel', 'hp@gmail.com', '7003216160', '15-aug-2020', 'Hp003', 7000, NULL, '90');
INSERT INTO employees VALUES('800', 'Kamlesh', 'Paul', 'kp@gmail.com', '7003216170', '17-feb-2020', 'Kp004', 8000, '506', '90');
INSERT INTO employees VALUES('900', 'Dinesh', 'Gandhi', 'dp@yahoo', '9136278563', '19-march-2101', 'Dg006', 20000, '508', '80');
INSERT INTO employees VALUES('701', 'Suresh', 'Modi', 'sm@dg.com', '9187653294', '20-april-2015', 'Sm009', 15000, NULL, '80');

ALTER TABLE employees ADD CONSTRAINT pk_employees PRIMARY KEY (employee_id);

-- 2.a. Display the employee_id, manager_id, first_name and last_name of those employees
-- who manage other employees having individual salary less than average salary of
-- person whose last_name starts with 'p' .
-- 2.a.
SELECT employee_id, manager_id, first_name, last_name FROM employees WHERE manager_id IS NOT NULL 
AND salary < (SELECT avg(salary) FROM employees WHERE last_name LIKE 'P%');

-- Question-3

CREATE TABLE salesman(salesman_id VARCHAR(10), name VARCHAR(20), city VARCHAR(20), commission NUMBER(3,2));
INSERT INTO salesman VALUES('si123@06', 'Lakshmi', 'Kolkata', 0.5);
INSERT INTO salesman VALUES('si123@09', 'Ganesh', 'London', 0.6);
INSERT INTO salesman VALUES('si123@90', 'Dinesh', 'London', 0.3);
INSERT INTO salesman VALUES('si123@10', 'Joseph', 'Chennai', 0.6);
INSERT INTO salesman VALUES('si123@19', 'Mahesh', 'Chennai', 0.65);
INSERT INTO salesman VALUES('si123@26', 'Paul Adam', 'London', 0.1);
INSERT INTO salesman VALUES('si123@67', 'Rahul', 'Kolkata', 0.4);

CREATE TABLE orders2(ord_no VARCHAR(3), Purch_amt NUMBER(10), Ord_date VARCHAR(15), Customer_id VARCHAR(5), Salesman_id VARCHAR(10));
INSERT INTO orders2 VALUES('123', 600, '20-aug-2010', '003cd', 'si123@19');
INSERT INTO orders2 VALUES('576', 750, '20-feb-2018', '004cd', 'si123@19');
INSERT INTO orders2 VALUES('579', 800, '20-may-2012', '004cd', 'si123@26');
INSERT INTO orders2 VALUES('600', 60000, '20-jan-2021', '006cd', 'si123@10');
INSERT INTO orders2 VALUES('700', 745, '26-jan-2021', '007cd', 'si123@09');
INSERT INTO orders2 VALUES('800', 860, '29-jan-2019', '007cd', 'si123@26');

ALTER TABLE salesman ADD CONSTRAINT pk_salesman PRIMARY KEY (salesman_id);
ALTER TABLE orders2 ADD CONSTRAINT fk_salesman FOREIGN KEY (salesman_id) REFERENCES salesman(salesman_id);

-- 3.a. Display all the orders for the salesman who belongs to the same city and the individual
-- commission of salesman is greater than the average commission of city.
-- 3.a.
SELECT * FROM orders2 WHERE salesman_id IN 
(SELECT s1.salesman_id FROM salesman s1, salesman s2 WHERE 
s1.salesman_id != s2.salesman_id AND s1.city = s2.city AND 
s1.commission > (select avg(commission) from salesman WHERE city = s1.city));

-- 3.b. Delete the salesman_id from table salesman whose commisson is greater than 0.2 and
-- set NA for the values not available in table orders.
-- 3.b.
ALTER TABLE orders2 DISABLE CONSTRAINT fk_salesman;
UPDATE orders2 SET salesman_id = 'NA' WHERE 
salesman_id IN (SELECT salesman_id FROM salesman WHERE commission > 0.2);
delete FROM salesman WHERE commission > 0.2;
SELECT * FROM salesman;
SELECT * FROM orders2;