create DATABASE if not EXISTS practice;

USE practice;

create table if not exists students (
    id TINYINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(30) UNIQUE,
    age TINYINT CHECK (age >= 18),
    city VARCHAR(20) NOT NULL,
    course VARCHAR(20)
);

insert into students (name, age, city, course) values
("bob", 25, "New Jerysey", "Mathematics"),
("alice", 22, "New York", "Physics"),
("charlie", 23, "Los Angeles", "Chemistry"),
("dave", 24, "Chicago", "Biology"),
("eve", 21, "Houston", "Mathematics"),
("frank", 26, "Phoenix", "Physics");

select city, count(name) from students GROUP BY city;


------------------eda with assignment 2 ---------------------

select count(city), count(age) from students GROUP BY city, age;

SELECT age, city, COUNT(*) AS number_of_students
FROM students
GROUP BY age, city;

SELECT city, GROUP_CONCAT(DISTINCT age ORDER BY age) AS distinct_ages
FROM students
GROUP BY city;

-- how many students are from each age group?

select age, count(age) as num_students from students group by age order by age;

-- how many students are from each city?

select city, count(*) as num_students from students group by city order by city;


select * from students where age > (select avg(age) from students);

select * from students where age in (select min(age) from students);

select city, count(*) from students GROUP BY city HAVING max(age);

----------------------------------------------------------------- 

alter table students add column score tinyint UNIQUE;

UPDATE students set score = 50 where id = 7;

CREATE table backup AS SELECT * FROM students;

ALTER table spec_info change column course spec VARCHAR(30);

UPDATE practice.spec_info
set spec = CASE student_id
    WHEN 1 THEN 'CSE'
    WHEN 2 THEN 'AM'
    WHEN 3 THEN 'IC'
    WHEN 4 THEN 'OC'
    WHEN 5 THEN 'MS'
    WHEN 6 THEN 'TM'
    WHEN 7 THEN 'EC'
    ELSE spec
END;

alter table spec_info drop column city;

alter table spec_info change column student_id std_id tinyint AUTO_INCREMENT FOREIGN KEY REFERENCES students(id);

show tables;

select * from spec_info;
select * from students;


----------------- JOINS -----------------

-- Inner Join
SELECT 
    students.id,
    students.name,
    students.age,
    students.course,
    spec_info.spec,
    spec_info.score
FROM students 
JOIN spec_info 
ON students.id = spec_info.std_id;

select * from students join spec_info on students.id = spec_info.std_id;

-- Full Outer Join
SELECT 
    students.id,
    students.name,
    students.age,
    students.course,
    spec_info.spec,
    spec_info.score
FROM students
LEFT JOIN spec_info ON students.id = spec_info.std_id

UNION

SELECT 
    students.id,
    students.name,
    students.age,
    students.course,
    spec_info.spec,
    spec_info.score
FROM spec_info
RIGHT JOIN students ON students.id = spec_info.std_id;

select * from students full outer join spec_info on students.id = spec_info.std_id; -- dosn't work in MySQL

-- Left Join
SELECT 
    students.id,
    students.name,
    students.age,
    students.course,
    spec_info.spec,
    spec_info.score
FROM students
LEFT JOIN spec_info ON students.id = spec_info.std_id;

-- Right Join
SELECT 
    students.id,
    students.name,
    students.age,
    students.course,
    spec_info.spec,
    spec_info.score
FROM spec_info
RIGHT JOIN students ON students.id = spec_info.std_id;

-- Union

select id, score
from students
union
select std_id, score
from spec_info
ORDER BY score DESC;

-- Union All

select id, score
from students
union all
select std_id, score
from spec_info
ORDER BY score DESC;

-- Intersect

select id, score
from students
intersect
select std_id, score
from spec_info
ORDER BY score DESC;

-- Cross Join
SELECT 
    students.id,
    students.name,
    students.age,
    students.course
FROM students
CROSS JOIN spec_info;

------------- Special Cases ---------------

-- Self Join
SELECT 
    s1.id AS student_id,
    s1.name AS student_name,
    s2.id AS friend_id,
    s2.name AS friend_name
FROM students s1
JOIN students s2 ON s1.id <> s2.id;

select * 
from students s1
join students s2 
on s1.id <> s2.id; -- dont even try to do this because it will return a Cartesian product of the table with itself

-- Natural Join
SELECT 
    students.id,
    students.name,
    students.age,
    students.course,
    spec_info.spec,
    spec_info.score
FROM students
NATURAL JOIN spec_info;

-- Semi Join
SELECT * FROM students
WHERE EXISTS (
  SELECT 1 FROM spec_info WHERE students.id = spec_info.std_id
);


-- A - B

SELECT 
    students.id,
    students.name,
    students.age,
    students.course,
    students.score,
    spec_info.spec
FROM students
LEFT JOIN spec_info ON students.id = spec_info.std_id
WHERE spec_info.std_id IS NULL;

-- Anti Left Join
SELECT s.*, b.spec
FROM students s
LEFT JOIN spec_info b ON s.id = b.std_id
WHERE b.std_id IS NULL;

-- B - A

SELECT 
    students.id,
    students.name,
    students.age,
    students.course,
    spec_info.spec,
    spec_info.score
FROM students
RIGHT JOIN spec_info ON students.id = spec_info.std_id
WHERE students.id IS NULL;

-- Anti Right Join
SELECT s.*, b.spec
FROM spec_info b
RIGHT JOIN students s ON s.id = b.std_id
WHERE s.id IS NULL;


----------- Concatenation Function -----------------


select id, concat(name, ' ', age) as student_info
from students;

select id, concat(course, ' - ', spec) as course_spec_info
from students
join spec_info on students.id = spec_info.std_id;


----------------- String Functions ----------------


select id, name, LENGTH(name) as name_length
from students
WHERE id in (2, 4, 7);

select SUBSTRING(name, 1) as name_prefix, age
from students;


------------ Date and Time Functions -----------------


SELECT NOW() AS current_datetime; -- returns the current date and time

SELECT DATE('2025-06-11 05:30:00') AS date_value; -- extracts date part from a datetime value
SELECT TIME('2025-06-11 20:45:00') AS time_value; -- extracts time part from a datetime value

-- Date Format: formats date and time values as specified
SELECT DATE_FORMAT(NOW(), '%Y-%m-%d') AS today_date;

SELECT DATE_FORMAT(NOW(), '%H:%i:%s') AS now_time;

SELECT DATE_FORMAT(NOW(), '%Y-%m-%d %H:%i:%s') AS current_date_time; -- this line works same as timestamp

-- timestamp function - combines date and time into a single value
SELECT TIMESTAMP('2025-06-11','20:45:00') AS timestamp_value;
SELECT TIMESTAMP("2025-06-12 00:00:00") AS timestamp_value;

-- Date Arithmetic Functions
SELECT DATE_ADD('2025-06-11', INTERVAL 5 DAY) AS date_plus_5_days; -- adds 5 days to a date
SELECT DATE_SUB('2025-06-11', INTERVAL 3 DAY) AS date_minus_3_days; -- subtracts 3 days from a date

SELECT DATE_ADD('2025-06-11', INTERVAL 2 MONTH) AS date_plus_2_months; -- adds 2 months to a date
SELECT DATE_SUB('2025-06-11', INTERVAL 1 YEAR) AS date_minus_1_year; -- subtracts 1 year from a date


---------------------------------------------------------


create table login (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

insert into login (username, password) values
('admin', 'admin123'),
('admin_jr', 'password'),
('admin_sr', '12345678'),
('admin_1', 'qwerty'),
('admin_2', 'asdfghjkl'),
('admin_3', 'zxcvbnm');

select * from login;

