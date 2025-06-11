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


----------------------- assignment 2 ---------------------

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

ALTER table bkp change column course spec VARCHAR(30);

UPDATE students s
JOIN temp_table t ON s.student_id = t.student_id
SET s.grade = t.new_grade;


UPDATE practice.bkp
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

alter table bkp drop column city;

alter table bkp change column student_id std_id tinyint AUTO_INCREMENT FOREIGN KEY REFERENCES students(id);

select * from bkp;
select * from students;


----------------- JOINS -----------------

-- Inner Join
SELECT 
    students.id,
    students.name,
    students.age,
    students.course,
    bkp.spec,
    bkp.score
FROM students 
JOIN bkp 
ON students.id = bkp.std_id;

select * from students join bkp on students.id = bkp.std_id;

-- Full Outer Join
SELECT 
    students.id,
    students.name,
    students.age,
    students.course,
    bkp.spec,
    bkp.score
FROM students
LEFT JOIN bkp ON students.id = bkp.std_id

UNION

SELECT 
    students.id,
    students.name,
    students.age,
    students.course,
    bkp.spec,
    bkp.score
FROM bkp
RIGHT JOIN students ON students.id = bkp.std_id;

select * from students full outer join bkp on students.id = bkp.std_id; -- dosn't work in MySQL

-- Left Join
SELECT 
    students.id,
    students.name,
    students.age,
    students.course,
    bkp.spec,
    bkp.score
FROM students
LEFT JOIN bkp ON students.id = bkp.std_id;

-- Right Join
SELECT 
    students.id,
    students.name,
    students.age,
    students.course,
    bkp.spec,
    bkp.score
FROM bkp
RIGHT JOIN students ON students.id = bkp.std_id;

-- Union

select id, score
from students
union
select std_id, score
from bkp
ORDER BY score DESC;

-- Union All

select id, score
from students
union all
select std_id, score
from bkp
ORDER BY score DESC;

-- Intersect

select id, score
from students
intersect
select std_id, score
from bkp
ORDER BY score DESC;

-- Cross Join
SELECT 
    students.id,
    students.name,
    students.age,
    students.course
FROM students
CROSS JOIN bkp;

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
on s1.id <> s2.id;

-- Natural Join
SELECT 
    students.id,
    students.name,
    students.age,
    students.course,
    bkp.spec,
    bkp.score
FROM students
NATURAL JOIN bkp;

-- Semi Join
SELECT * FROM students
WHERE EXISTS (
  SELECT 1 FROM bkp WHERE students.id = bkp.std_id
);


-- A - B

SELECT 
    students.id,
    students.name,
    students.age,
    students.course,
    students.score,
    bkp.spec
FROM students
LEFT JOIN bkp ON students.id = bkp.std_id
WHERE bkp.std_id IS NULL;

-- Anti Left Join
SELECT s.*, b.spec
FROM students s
LEFT JOIN bkp b ON s.id = b.std_id
WHERE b.std_id IS NULL;

-- B - A

SELECT 
    students.id,
    students.name,
    students.age,
    students.course,
    bkp.spec,
    bkp.score
FROM students
RIGHT JOIN bkp ON students.id = bkp.std_id
WHERE students.id IS NULL;

-- Anti Right Join
SELECT s.*, b.spec
FROM bkp b
RIGHT JOIN students s ON s.id = b.std_id
WHERE s.id IS NULL;


--------------Special Functions---------------------

-- Concatenation
select id, concat(name, ' ', age) as student_info
from students
WHERE id = 4;

-- String Functions
select id, name, LENGTH(name) as name_length
from students
WHERE id = 2;

select SUBSTRING(name, 1) as name_prefix, age
from students;
-- WHERE id = 2;

SELECT GETDATE() AS current_date_time;
SELECT DATE_FORMAT(NOW(), '%Y-%m-%d %H:%i:%s') AS current_date_time;

SELECT DATE('2023-10-01') AS date_value;
SELECT TIME('12:30:00') AS time_value;

SELECT TIMESTAMP('2023-10-01 12:30:00') AS timestamp_value;
SELECT DATE_FORMAT(NOW(), '%Y-%m-%d') AS c_date;
SELECT DATE_FORMAT(NOW(), '%H:%i:%s') AS c_time;