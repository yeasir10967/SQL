-- DATABASE SETUP
-- Create and select the database
CREATE DATABASE IF NOT EXISTS varsity;
USE varsity;

-- TABLE CREATION
-- Create the 'student_uni' table to store student information
CREATE TABLE student_uni (
    roll INT PRIMARY KEY, -- Primary key to uniquely identify each student
    name VARCHAR(50), -- Name of the student
    mark INT NOT NULL, -- Marks obtained by the student (non-null)
    grade VARCHAR(2), -- Grade of the student (e.g., A+, B)
    city VARCHAR(20) -- City of the student
);

-- Create the 'dept' table to store department information
CREATE TABLE dept (
    id INT PRIMARY KEY, -- Primary key for department
    name VARCHAR(50) -- Name of the department
);

-- DATA MANIPULATION
-- Insert sample data into the 'dept' table
INSERT INTO dept VALUES 
(101, "english"), -- English department
(102, "science"); -- Science department

-- Display all records in the 'dept' table
SELECT * FROM dept;

-- Update a record in the 'dept' table
UPDATE dept
SET id = 103 -- Update department ID from 102 to 103
WHERE id = 102;

-- Create the 'teacher' table to store teacher information and link it to 'dept'
CREATE TABLE teacher (
    id INT PRIMARY KEY, -- Unique identifier for teacher
    name VARCHAR(50), -- Name of the teacher
    dept_id INT, -- Foreign key linking to 'dept' table
    FOREIGN KEY (dept_id) REFERENCES dept(id)
    ON UPDATE CASCADE -- Cascade updates to linked records
    ON DELETE CASCADE -- Cascade deletions to linked records
);

-- Drop the 'teacher' table (if needed)
DROP TABLE teacher;

-- Insert sample data into the 'teacher' table
INSERT INTO teacher VALUES
(1001, "adam", 101), -- Teacher Adam in English department
(1002, "adam", 102); -- Teacher Adam in Science department

-- Display all records in the 'teacher' table
SELECT * FROM teacher;

-- Insert sample data into the 'student_uni' table with a conflict resolution mechanism
INSERT INTO student_uni 
(roll, name, mark, grade, city)
VALUES
(101, 'yeasir', 97, 'A+', 'new york'), -- High-performing student from New York
(102, 'jack', 87, 'A+', 'new jersey'), -- High-performing student from New Jersey
(103, 'anoy', 79, 'B', 'new town'), -- Average-performing student
(104, 'akhil', 59, 'D', 'new york'), -- Below average student
(105, 'alex', 12, 'F', 'capetown'), -- Failing student
(106, 'chandan', 67, 'C', 'colombia') -- Satisfactory performance
ON DUPLICATE KEY UPDATE 
    name = VALUES(name), -- Update name if duplicate key
    mark = VALUES(mark), -- Update marks
    grade = VALUES(grade), -- Update grade
    city = VALUES(city); -- Update city

-- QUERIES
-- Display specific columns and all records from 'student_uni'
SELECT name, mark FROM student_uni; -- View names and marks
SELECT * FROM student_uni; -- View all student information

-- Display distinct cities from 'student_uni'
SELECT DISTINCT city FROM student_uni; -- Unique cities in the table

-- Filter students based on conditions
SELECT * FROM student_uni WHERE mark > 80; -- High-performing students
SELECT * FROM student_uni WHERE mark > 50 AND city = "NEW YORK"; -- Filter by marks and city
SELECT * FROM student_uni WHERE mark BETWEEN 70 AND 100; -- Marks in a range
SELECT * FROM student_uni WHERE city IN ("new york", "new town"); -- Students from specific cities
SELECT * FROM student_uni WHERE city NOT IN ("new york", "new town"); -- Exclude specific cities

-- Limit query results
SELECT * FROM student_uni LIMIT 3; -- First three records
SELECT * FROM student_uni WHERE mark > 80 LIMIT 3; -- Top three high-performers

-- Sort query results
SELECT * FROM student_uni ORDER BY mark ASC; -- Ascending order of marks
SELECT * FROM student_uni ORDER BY mark DESC; -- Descending order of marks
SELECT * FROM student_uni WHERE mark > 80 ORDER BY mark DESC; -- Filter and sort
SELECT * FROM student_uni ORDER BY mark DESC LIMIT 2; -- Top two students

-- Aggregate functions
SELECT MAX(mark) FROM student_uni; -- Highest mark
SELECT MIN(mark) FROM student_uni; -- Lowest mark
SELECT SUM(mark) FROM student_uni; -- Total marks
SELECT AVG(mark) FROM student_uni; -- Average marks
SELECT COUNT(name) FROM student_uni; -- Total number of students

-- Grouping and aggregation
SELECT name, city FROM student_uni GROUP BY city, name; -- Group by city and name
SELECT city, AVG(mark) FROM student_uni GROUP BY city ORDER BY AVG(mark); -- Average marks per city

-- Conditional query
SELECT city
FROM student_uni
WHERE grade = 'A+' AND mark > 80 -- High-performing students with A+ grade
ORDER BY city DESC
LIMIT 0, 1000; -- Limit results

-- DATA UPDATES
-- Update multiple records
SET SQL_SAFE_UPDATES = 0; -- Disable safe update mode
UPDATE student_uni
SET grade = 'O' -- Update grade to 'O'
WHERE grade = "A+";
SELECT * FROM student_uni;

-- Update specific record
UPDATE student_uni
SET mark = 40 -- Update mark for roll 105
WHERE roll = 105;

-- Delete records based on conditions
DELETE FROM student_uni
WHERE mark < 50; -- Remove failing students
SELECT * FROM student_uni;

-- TABLE MODIFICATIONS
-- Modify the 'student_uni' table
ALTER TABLE student_uni
ADD COLUMN age INT NOT NULL DEFAULT 20; -- Add age column with default value
ALTER TABLE student_uni
MODIFY COLUMN age VARCHAR(2); -- Change age column type
INSERT INTO student_uni
(roll, name, mark, grade, city, student_age)
VALUES
(111, "Tom", 34, "F", "DHAKA", 100); -- Add new student
SELECT * FROM student_uni;

-- Rename and drop columns
ALTER TABLE student_uni
CHANGE age student_age INT; -- Rename age to student_age
ALTER TABLE student_uni
DROP COLUMN age; -- Remove the age column

-- Rename the table
RENAME TABLE student_unii TO student_uni; -- Fix table name

-- Truncate the table
TRUNCATE TABLE student_uni; -- Remove all records

-- JOINS
-- Create and populate 'student' and 'course' tables
CREATE TABLE student (
    id INT PRIMARY KEY, -- Student ID
    name VARCHAR(50) -- Student name
);
CREATE TABLE course (
    id INT PRIMARY KEY, -- Course ID
    course VARCHAR(50) -- Course name
);

INSERT INTO student (id, name)
VALUES
(101, "karim"), -- Student Karim
(102, "rahim"); -- Student Rahim

INSERT INTO course (id, course)
VALUES
(101, "english"), -- English course
(105, "math"); -- Math course

-- Perform various joins
SELECT *
FROM student
INNER JOIN course
ON student.id = course.id; -- Students with courses

SELECT *
FROM student
LEFT JOIN course
ON student.id = course.id; -- All students and their courses (if any)

SELECT *
FROM student
RIGHT JOIN course
ON student.id = course.id; -- All courses and their students (if any)

SELECT *
FROM student
LEFT JOIN course
ON student.id = course.id
UNION
SELECT *
FROM student
RIGHT JOIN course
ON student.id = course.id; -- Combine results from both joins

SELECT *
FROM student
LEFT JOIN course
ON student.id = course.id
WHERE course.id IS NULL; -- Students without courses

-- ADVANCED OPERATIONS
-- Create and query the 'employee' table
CREATE TABLE employee (
    id INT PRIMARY KEY, -- Employee ID
    name VARCHAR(50), -- Employee name
    manager_id INT -- Manager ID
);

INSERT INTO employee (id, name, manager_id)
VALUES
(101, "adam", 103), -- Employee Adam reports to Casey
(102, "bob", 104), -- Employee Bob reports to Donald
(103, "casey", NULL), -- Manager Casey
(104, "donald", 103); -- Manager Donald reports to Casey

-- Self-join to find managers
SELECT *
FROM employee AS a
JOIN employee AS b
ON a.id = b.manager_id; -- Employees and their managers

SELECT a.name AS manager_name, b.name
FROM employee AS a
JOIN employee AS b
ON a.id = b.manager_id; -- Managers and their direct reports

-- Subqueries
SELECT name, mark
FROM student_uni
WHERE mark > (SELECT AVG(mark) FROM student_uni); -- Students above average marks

SELECT MAX(mark)
FROM (
    SELECT *
    FROM student_uni
    WHERE city = "new york"
) AS tmp; -- Highest mark in New York

-- Create and query views
CREATE VIEW view1 AS
SELECT roll, mark, city 
FROM student_uni; -- Create view with specific columns

SELECT * FROM view1
WHERE mark > 90; -- Query the view for high-performing students


