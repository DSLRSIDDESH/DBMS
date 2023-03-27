DROP TABLE course_taken;
DROP TABLE course_required;
DROP TABLE t1;
DROP TABLE s;
DROP TABLE t2_before;
DROP TABLE t2;
DROP TABLE eligible;

CREATE TABLE course_taken(student_name varchar(20), course varchar(30));

INSERT INTO course_taken VALUES('Robert', 'Databases');
INSERT INTO course_taken VALUES('Robert', 'Programming Languages');
INSERT INTO course_taken VALUES('David', 'Databases');
INSERT INTO course_taken VALUES('Hannah', 'Programming Languages');
INSERT INTO course_taken VALUES('Hannah', 'Programming Languages');
INSERT INTO course_taken VALUES('Tom', 'Operating systems');
INSERT INTO course_taken VALUES('David', 'Operating systems');

CREATE TABLE course_required(course varchar(30));

INSERT INTO course_required VALUES('Databases');
INSERT INTO course_required VALUES('Programming Languages');

-- 1.a. Create a set of all students that have taken courses.

CREATE TABLE t1 AS
SELECT distinct(student_name) FROM course_taken;
SELECT * FROM t1;

-- 1.b. Find and create set of all the student and the courses required to graduate.

CREATE TABLE s AS
SELECT student_name, course FROM t1, course_required;
SELECT * FROM s;

-- 1.c. Find and create all the students and the required courses they have not taken.

CREATE TABLE t2_before AS
SELECT * FROM s
MINUS SELECT * from course_taken;
SELECT * FROM t2_before;

-- 1.d. Find and create all the students who cannot graduate. (Join not allowed)

CREATE TABLE t2 AS
SELECT distinct(student_name) from t2_before;
select * from t2;

-- 1.e. Find and create all the students who can graduate. (Join not allowed)

CREATE TABLE eligible AS
SELECT * FROM t1
MINUS
SELECT * FROM t2;
SELECT * FROM eligible;

-- Question-2 => Method-1
SELECT student_name FROM t1 intersect SELECT student_name FROM t2_before;
-- Question-2 => Method-2
SELECT distinct(student_name) FROM (SELECT * FROM
(SELECT distinct(student_name) FROM course_taken),
(SELECT course FROM course_required)
MINUS SELECT student_name, course FROM course_taken);
-- Question-2 => Method-3
CREATE TABLE required AS 
(SELECT * FROM course_taken WHERE 
course = ANY(SELECT course FROM course_required));
CREATE TABLE non_eligible AS SELECT DISTINCT(student_name) FROM 
(SELECT * FROM s MINUS SELECT * FROM required);
SELECT * FROM non_eligible;