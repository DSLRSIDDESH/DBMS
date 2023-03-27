CREATE TABLE committees(committee_id varchar(6), name varchar(20));
INSERT INTO committees VALUES('101', 'Ramesh');
INSERT INTO committees VALUES('102', 'Suresh');
INSERT INTO committees VALUES('103', 'Hritik');

CREATE TABLE member(member_id varchar(6), name varchar(20));
INSERT INTO member VALUES('m101', 'Ramesh');
INSERT INTO member VALUES('m102', 'Suresh');
INSERT INTO member VALUES('m103', 'Rakesh');

-- 1.a) Find Name of person in committees who is not a member.

SELECT committees.name from committees LEFT JOIN member on committees.name = member.name
MINUS
SELECT committees.name from committees INNER JOIN member on committees.name = member.name;

-- 1.b) Find the Name of member who is not in committees list.

SELECT member.name from member LEFT JOIN committees on member.name = committees.name
MINUS
SELECT member.name from member INNER JOIN committees on member.name = committees.name;

-- 1.c) Find the name of person in committees having same age (Add column age in
-- committees and set value 20,20,30 respectively).

ALTER TABLE committees ADD age number(2);
UPDATE committees SET age = 20 where committee_id = '101';
UPDATE committees SET age = 20 where committee_id = '102';
UPDATE committees SET age = 30 where committee_id = '103';
SELECT distinct(a.name) as common_name from committees a, 
committees b where a.age = b.age and a.name != b.name;

-- 2) Find the roll number and names of students who have taken atleast one course
-- taught by his or her advisor.

SELECT distinct(student.rollno),student.name from student
INNER JOIN enrollment ON student.rollno = enrollment.rollNo
INNER JOIN teaching ON enrollment.courseid = teaching.courseid 
and student.advisor = teaching.empId;

-- 3) What are those courses that are either pre-requisites of 608 or pre-requisites of
-- the prerequisites of the course 608(give course numbers, and course names)?

SELECT courseid, cname from course where courseid in
(SELECT prereqcourse FROM prerequisite where courseid = '608'
UNION
SELECT prereqcourse FROM prerequisite where courseid in 
(SELECT prereqcourse FROM prerequisite where courseid = '608'));

-- 4) Find all the students who have not taken any course offered by the teachers of
-- course 319.

SELECT distinct(student.rollno),student.name from student
MINUS
SELECT distinct(student.rollno),student.name from student
INNER JOIN enrollment ON enrollment.rollno = student.rollno
AND enrollment.courseid IN 
(SELECT courseid from teaching where empid in 
(SELECT empid from teaching where courseid = '319'));

-- 5) Find roll no of students who have got S grade in all prerequisites of the course
-- 760.

SELECT student.rollno from student
INNER JOIN enrollment ON student.rollno = enrollment.rollno and grade = 'S'
INNER JOIN prerequisite ON enrollment.courseid = prerequisite.prereqcourse
and prerequisite.courseid = '760';

-- 6) Find name and roll no of student who have taken course multiple times.

SELECT distinct(rollno),name from student where rollno IN
(SELECT e1.rollno FROM enrollment e1, enrollment e2 WHERE 
e1.rollno = e2.rollno and e1.courseid = e2.courseid and (e1.sem != e2.sem OR e1.year != e2.year));