-- Using the DB
USE pregrad;

-- Creating the employees table
CREATE TABLE IF NOT EXISTS employees (
    id TINYINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) UNIQUE,
    age TINYINT CHECK (age >= 18),
    city VARCHAR(50) NOT NULL,
    salary INT
);

-- Load the file and view the employees table
LOAD DATA LOCAL INFILE 'C:\\Users\\AGAMDEEP SINGH\\Desktop\\Python\\PreGrad AI & ML Course\\A2\\employee_data_sql.csv'
INTO TABLE employees
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

select * from employees;


-- Answers to the Assignment Questions


-- Answer 1: details of employees from specific cities

select * from employees where city like "%Ban%"; -- Bangalore

select * from employees where city like "%Gur%"; -- Gurgaon

select * from employees where city like "%Mum%"; -- Mumbai

select * from employees where city like "%No%"; -- Noida

select * from employees where city like "%Pune%"; -- Pune

-- Answer 2: average salary of employees from each city

select city,avg(salary) as average_salary_city from employees group by city order by city asc;

-- Answer 3: employees above 50 years of age

select id,name,age as above_50 from employees where age > 50 order by age asc; -- average salary

-- Answer 4: highest and lowest salary

select id,name,salary  as highest_salary from employees where salary in (select max(salary) from employees); -- highest salary

select id,name,salary  as lowest_salary from employees where salary in (select min(salary) from employees); -- lowest salary

-- Answer 5: employees from each city

select city, COUNT(*) AS num_emp_city from employees group by city order by city;

-- Answer 6: sorting employees with salery greater than 70000 in descending order

select id,name,salary from employees where salary > 70000 order by salary desc;

-- Answer 7: sorting employees by salary in descending order

select id,name,salary from employees order by salary desc;

-- Answer 8: average age of employees

select avg(age) as average_age from employees;

-- Answer 9: names starting with specific letters - D and K

select * from employees as name_from_specific_letters 
where name like "%D%" or name like "%K%";

-- Answer 10: total salary expenditure

select sum(salary) as total_salary_exp from employees;
