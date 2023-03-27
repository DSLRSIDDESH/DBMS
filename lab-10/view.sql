set linesize 1000;
set pagesize 1000;

DROP TABLE Enrolled;
DROP TABLE Student;
DROP TABLE Course;

CREATE TABLE Student(RollNo varchar2(8), SName varchar2(20), 
Gender varchar2(1), City varchar2(20), PRIMARY KEY(RollNo));

INSERT INTO Student VALUES('1901CS99', 'Rakesh', 'M', 'Kolkata');
INSERT INTO Student VALUES('1901CS98', 'Suresh', 'M', 'Bengalore');
INSERT INTO Student VALUES('1901CS97', 'Jennie', 'F', 'Delhi');
INSERT INTO Student VALUES('1901CS94', 'Lisa', 'F', 'Chennai');
INSERT INTO Student VALUES('1901CS96', 'Raman', 'M', 'Hyderabad');
INSERT INTO Student VALUES('1901CS95', 'Rahul', 'M', 'Chennai');

CREATE TABLE Course(CCode varchar2(5), CName varchar2(20), Credit number, PRIMARY KEY(CCode));

INSERT INTO Course VALUES('CS354', 'DBMS', 4);
INSERT INTO Course VALUES('ME305', 'EngineeringMechanics', 3);
INSERT INTO Course VALUES('CS355', 'Operating System', 2);
INSERT INTO Course VALUES('CS536', 'Computer Networks', 3);
INSERT INTO Course VALUES('CS357', 'Compiler Design', 4);
INSERT INTO Course VALUES('CS361', 'DAA', 4);

CREATE TABLE Enrolled(RollNo varchar2(8), CCode varchar2(5), YoE number);

INSERT INTO Enrolled VALUES('1901CS99', 'CS354', 2019);
INSERT INTO Enrolled VALUES('1901CS97', 'CS355', 2018);
INSERT INTO Enrolled VALUES('1901CS95', 'CS536', 2020);
INSERT INTO Enrolled VALUES('1901CS95', 'CS357', 2020);
INSERT INTO Enrolled VALUES('1901CS95', 'ME305', 2020);
INSERT INTO Enrolled VALUES('1901CS95', 'CS354', 2020);
INSERT INTO Enrolled VALUES('1901CS95', 'CS355', 2020);
INSERT INTO Enrolled VALUES('1901CS94', 'CS354', 2019);
INSERT INTO Enrolled VALUES('1901CS94', 'ME305', 2019);
INSERT INTO Enrolled VALUES('1901CS94', 'CS355', 2019);
INSERT INTO Enrolled VALUES('1901CS94', 'CS536', 2019);
INSERT INTO Enrolled VALUES('1901CS94', 'CS357', 2019);
INSERT INTO Enrolled VALUES('1901CS94', 'CS361', 2019);

ALTER TABLE Enrolled ADD CONSTRAINT FK_Enrolled_Student FOREIGN KEY (RollNo) REFERENCES Student(RollNo);
ALTER TABLE Enrolled ADD CONSTRAINT FK_Enrolled_Course FOREIGN KEY (CCode) REFERENCES Course(CCode);

-- Question-A
ALTER TABLE Course ADD CType varchar2(20);
UPDATE Course SET CType = 'Core' WHERE CCode = 'CS354';
UPDATE Course SET CType = 'Elective' WHERE CCode = 'ME305';
UPDATE Course SET CType = 'Open Elective' WHERE CCode = 'CS355';
UPDATE Course SET CType = 'Core' WHERE CCode = 'CS536';
UPDATE Course SET CType = 'Elective' WHERE CCode = 'CS357';

ALTER TABLE Student ADD Email varchar2(30);
UPDATE Student SET Email = '1901CS99@iiitdm.ac.in' WHERE RollNo = '1901CS99';
UPDATE Student SET Email = '1901CS98@gmail.com' WHERE RollNo = '1901CS98';
UPDATE Student SET Email = '1901CS97@yahoo.com' WHERE RollNo = '1901CS97';
UPDATE Student SET Email = '1901CS96@iiitdm.ac.in' WHERE RollNo = '1901CS96';
UPDATE Student SET Email = '1901CS95@gmail.com' WHERE RollNo = '1901CS95';
UPDATE Student SET Email = '1901CS94@gmail.com' WHERE RollNo = '1901CS94';

-- Question-B
-- Find the name of all the courses which start with “CS” code.
CREATE VIEW CS_Course AS
SELECT CName FROM Course WHERE CCode LIKE 'CS%';
SELECT * FROM CS_Course;
-- Question-C
-- Find the name of the male students who have at least two “a”s in their names.
CREATE VIEW Name_aa AS
SELECT Sname FROM Student WHERE Gender = 'M' and Sname LIKE '%a%a%';
SELECT * FROM Name_aa;
-- Question-D
-- Find the students who have not enrolled in between 2018 and 2019.
CREATE VIEW NotEnrolled AS
SELECT distinct(RollNo) FROM Enrolled WHERE YoE NOT BETWEEN 2018 AND 2019;
SELECT * FROM NotEnrolled;
-- Question-E
-- Find the course with least credit.
CREATE VIEW LeastCredit AS
SELECT CName,Credit FROM Course WHERE Credit = (SELECT MIN(Credit) FROM Course);
SELECT * FROM LeastCredit;
-- Question-F
-- Find the name of the Course which is not enrolled by any students in the year 2020.
CREATE VIEW NotEnrolled2020 AS
SELECT CName FROM Course WHERE CCode NOT IN (SELECT CCode FROM Enrolled WHERE YoE = 2020);
SELECT * FROM NotEnrolled2020;
-- Question-G
-- Find the total number of students city wise.
CREATE VIEW CityWise AS
SELECT City, count(*) AS count FROM Student GROUP BY City;
SELECT * FROM CityWise;
-- Question-H
-- Find the Rollno of the students who have enrolled to 5 number of courses.
CREATE VIEW Enrolled5 AS
SELECT RollNo FROM Enrolled GROUP BY RollNo HAVING COUNT(*) = 5;
SELECT * FROM Enrolled5;
-- Question-I
-- Find the total number of courses enrolled by student with roll no “1901CS99”.
CREATE VIEW Enrolled1901CS99 AS
SELECT count(CCode) AS count FROM Enrolled WHERE RollNo = '1901CS99';
SELECT * FROM Enrolled1901CS99;
-- Question-J
-- Find all the 5 level courses (the digits parts of the course code shouldstart with 5).
CREATE VIEW Level5 AS
SELECT CName FROM Course WHERE CCode LIKE '__5%';
SELECT * FROM Level5;
-- Question-K
-- Count the number of students containing “CS” as part of the RollNo.
CREATE VIEW CS_RollNo AS
SELECT count(*) AS count FROM Student WHERE RollNo LIKE '%CS%';
SELECT * FROM CS_RollNo;
-- Question-L
-- Find the roll no of students who have enrolled in more than 4 courses in the year 2020.
CREATE VIEW EnrolledMoreThan4 AS
SELECT RollNo FROM Enrolled WHERE YoE = 2020 GROUP BY RollNo HAVING COUNT(*) > 4;
SELECT * FROM EnrolledMoreThan4;
-- Question-M
-- Find the course code which is taken by most female students who are from Delhi city.
CREATE VIEW MostFemaleDelhi AS
SELECT CCode FROM Enrolled WHERE RollNo IN 
(SELECT Rollno from Student where Gender = 'F' and City = 'Delhi') 
GROUP BY CCode HAVING COUNT(*) = (SELECT MAX(count) 
FROM (SELECT COUNT(*) AS count FROM Enrolled WHERE 
RollNo IN (SELECT Rollno from Student where 
Gender = 'F' and City = 'Delhi') GROUP BY CCode));  
SELECT * FROM MostFemaleDelhi;
-- Question-N
-- Find the name of all the students whose email ids have “gmail.com”
-- or “yahoo.com” as the domain name.
CREATE VIEW GmailYahoo AS
SELECT SName FROM Student WHERE Email LIKE '%gmail.com' or Email LIKE '%yahoo.com';
SELECT * FROM GmailYahoo;
-- Question-O
-- find the name of students enrolled in all courses.
CREATE VIEW EnrollAllCourses AS
SELECT SName FROM Student WHERE RollNo IN 
(SELECT RollNo FROM Enrolled GROUP BY RollNo 
HAVING COUNT(CCode) = (SELECT COUNT(CCode) FROM Course));
SELECT * FROM EnrollAllCourses;