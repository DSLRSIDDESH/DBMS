DROP TABLE empinfo;
set linesize 1000;
set pagesize 1000;
SET serveroutput ON

-- Question-1
DECLARE
    a integer;
    b integer;
    c integer;
    d integer;
BEGIN
    a := &a;
    b := &b;
    c := &c;
    dbms_output.put_line('a : ' || a);
    dbms_output.put_line('b : ' || b);
    dbms_output.put_line('c : ' || c);
    IF(a > b) THEN
        IF(a > c) THEN
            d := a;
        ELSE
            d := c;
        END IF;
    ELSE
        IF(b > c) THEN
            d := b;
        ELSE
            d := c;
        END IF;
    END IF;
    dbms_output.put_line('maximum number : ' || d);
END;
/

-- Question-2
DECLARE
    num integer;
    a integer;
BEGIN
    num := &num;
    dbms_output.put_line('Entered number is : ' || num);
    IF (mod(num,5) = 0) THEN
        a := 1;
    ELSE
        a := 0;
    END IF;
    IF (mod(num,11) = 0) THEN
        a := a + 1;
    END IF;
    IF (a = 2) THEN
        dbms_output.put_line('THe number is divisible by 5 and 11');
    ELSE
        dbms_output.put_line('THe number is not divisible by 5 and 11');
    END IF;
END;
/

-- Question-3: Find the area of rectangle, triangle, and square.
DECLARE
    lenght integer;
    breadth integer;
    side_a integer;
    side_b integer;
    side_c integer;
    s NUMBER(10,2);
    side integer;
BEGIN
    lenght := &lenght;
    breadth := &breadth;
    side_a := &side_a;
    side_b := &side_b;
    side_c := &side_c;
    side := &side;
    s := (side_a + side_b + side_c) / 2;
    dbms_output.put_line('----------------------------------');
    dbms_output.put_line('Area of rectangle : ' || (lenght * breadth));
    dbms_output.put_line('Area of triangle : ' || SQRT(s * (s-side_a) * (s-side_b) * (s-side_c)));
    dbms_output.put_line('Area of square : ' || (side * side));
END;
/

-- Question-4
-- Write a C program to input marks of five subjects Physics, Chemistry, Biology,
-- Mathematics and Computer. Calculate percentage and grade according to following:
-- Percentage >= 90% : Grade A
-- Percentage >= 80% : Grade B
-- Percentage >= 70% : Grade C
-- Percentage >= 60% : Grade D
-- Percentage >= 40% : Grade E
-- Percentage < 40% : Grade F
DECLARE
    phy integer;
    chem integer;
    bio integer;
    math integer;
    com integer;
    percentage integer;
BEGIN
    phy := &phy;
    chem := &chem;
    bio := &bio;
    math := &math;
    com := &com;
    percentage := (phy + chem + bio + math + com) / 5;
    dbms_output.put_line('Percentage : ' || percentage);
    IF (percentage >= 90) THEN
        dbms_output.put_line('Grade : A');
    ELSIF (percentage >= 80) THEN
        dbms_output.put_line('Grade : B');
    ELSIF (percentage >= 70) THEN
        dbms_output.put_line('Grade : C');
    ELSIF (percentage >= 60) THEN
        dbms_output.put_line('Grade : D');
    ELSIF (percentage >= 40) THEN
        dbms_output.put_line('Grade : E');
    ELSE
        dbms_output.put_line('Grade : F');
    END IF;
END;
/

-- Question-5: Find sum of 100 natural number using loop
DECLARE
    a number := 0;
    i number := 1;
BEGIN
    WHILE (i<=100) LOOP
        a := a + i;
        i := i + 1;
    END LOOP;
    dbms_output.put_line('Sum of first 100 natural numbers : ' || a);
END;
/

CREATE TABLE empinfo(id varchar2(1), name varchar2(15), age number(2), 
address varchar(20), salary number(5));
INSERT INTO empinfo VALUES('1', 'Ramesh', 32, 'Ahmedabad', 2000);
INSERT INTO empinfo VALUES('2', 'Khilan', 25, 'Delhi', 1500);
INSERT INTO empinfo VALUES('3', 'kaushik', 23, 'Kota', 2000);
INSERT INTO empinfo VALUES('4', 'Chaitali', 25, 'Mumbai', 6500);
INSERT INTO empinfo VALUES('5', 'Hardik', 27, 'Bhopal', 8500);
INSERT INTO empinfo VALUES('6', 'Komal', 22, 'MP', 4500);
ALTER TABLE empinfo ADD CONSTRAINT pk_empinfo PRIMARY KEY (id);

-- Question-6.A: Find the name of person having id =1
-- Output= The name of person having id=1 is Ramesh
DECLARE
    a varchar2(15);
BEGIN
    SELECT name INTO a FROM empinfo WHERE id = 1;
    dbms_output.put_line('The name of person having id=1 is ' || a);
END;
/
-- Question-6.B: Find the name,age, salary lives in kota.
-- Output: The name, age, and salary lives in kota is Kaushik, 23, and 2000.
DECLARE
    c_name varchar2(20);
    c_age number(2);
    c_salary number(5);
BEGIN
    SELECT name, age, salary INTO c_name, c_age, c_salary FROM empinfo WHERE address = 'Kota';
    dbms_output.put_line('The name, age, and salary lives in kota is ' 
    || c_name || ', ' || c_age || ', and ' || c_salary);
END;
/