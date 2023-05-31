-- 1) Parth Gulati              131697211      dbs311_222za09

------------------------------------------------------------------------------------------------------------------------------

-- 2)
-- USE the ON method of join .. Be sure to layout the SQL in a readable format
-- Display all orders for United States of America. The COUNTRY_NAME can be either hard coded or accepted from the user -- 
-- your choice. BUT-- You need to have United States of America and not US. Show only cities that start with L 
-- Also display with it any orders for Mexico for cities that start with C
-- What dooes the user want displayed ...(1) customer number, (2) customer name, (3) address1, (4) order number, 
-- (5) product name,?(6) the total dollars sales for that line on the order.  
-- Give that last column the name of     $ Sales. On this question I am accepting an alias column name
-- Put the output into?customer?number?order from highest to lowest.
SELECT
    c.cust_no,
    c.cname,
    c.address1,
    o.order_no,
    p.prod_name,
    SUM((od.price * od.qty)) AS "$ Sales"
FROM customers c 
INNER JOIN orders o ON c.cust_no = o.cust_no
INNER JOIN orderlines od ON o.order_no = od.order_no 
INNER JOIN countries ct ON c.country_cd = ct.country_id
INNER JOIN products p ON p.prod_no = od.prod_no
WHERE (ct.country_name = 'United States of America' AND c.city LIKE 'L%')
OR (ct.country_name = 'Mexico' AND c.city LIKE 'C%')
GROUP BY c.cust_no, c.cname, c.address1, o.order_no, p.prod_name
ORDER BY 1 DESC;

----------------------------------------------------------------------------------------------------------------------------

-- 3) 
-- MUST USE the ON style of JOIN
-- The manager of advertissing along withthe marketing manager wants information as follows:
-- For any customers with customer names that include  ==> Out  in any case in the name. 
-- provide (1) customer number, (2) customer name (3) address1 (4) city (5) order number and (6) product number
-- but only if they ordered any of these products -- 40301, 40503, 40303, 40306, 50203, 60201, 60101, 60400  
-- Put result in order number order. 
SELECT
    c.cust_no,
    c.cname,
    c.address1,
    c.city,
    ol.order_no,
    p.prod_no
FROM customers c
INNER JOIN orders o ON c.cust_no = o.cust_no
INNER JOIN orderlines ol ON o.order_no = ol.order_no
INNER JOIN products p ON ol.prod_no = p.prod_no
WHERE UPPER(c.cname) LIKE '%OUT%' AND p.prod_no IN (40301,40503,40303,40306,50203,60201,60101,60400)
ORDER BY ol.order_no;

------------------------------------------------------------------------------------------------------------------------------

-- 4)
-- Display the (1) customers number, (2) customers name and (3) country code for all the customers in United States
-- Get the country code from the user. Table used for country code is CUSTOMERS. 
-- Please note that the user is to enter the 2 character country code AND as an example 
-- only if they were doing Germany they could enter it as De, DE, de as examples meaning you have to allow for any combination..
-- Be flexible and helpful. NOTE: again the user is not entering the country name.
SELECT
    cust_no,
    cname,
    country_cd
FROM customers
WHERE UPPER(country_cd) LIKE UPPER('&ENTER_COUNTRY_CODE');



------------------------------------------------------------------------------------------------------------------------------

-- 5)
-- Supply order date and count of the number of orders on that date.. Use the ORDERS table.
-- Only include those dates in 2019 , 2020 and 2021
-- also only show those with more than 2 orders
SELECT 
    order_dt,
    COUNT(order_no)
FROM orders
WHERE order_dt BETWEEN '01-Jan-2019' AND '31-Dec-2021' 
GROUP BY ORDER_DT 
HAVING COUNT(ORDER_NO) > 2;


------------------------------------------------------------------------------------------------------------------------------

-- 6)
-- CAUTION: DO NOT USE ALIAS NAMES for columns
-- Use ON type of join
-- Find the total dollar value for all orders from customers in the cities that start with letters   -- >' to'   in any case
-- Each row will show (1) customer number, (2) customer name, (3) address1, (4) city and 
-- (5) order number and (6) total dollars for that order.  Sort by highest total first
SELECT
    c.cust_no,
    c.cname,
    c.address1,
    c.city,
    o.order_no,
    SUM((od.price * od.qty))
FROM customers c 
INNER JOIN orders o ON c.cust_no = o.cust_no
INNER JOIN orderlines od ON o.order_no = od.order_no
WHERE UPPER(c.city) LIKE UPPER('to%') 
GROUP BY c.cust_no, c.cname, c.address1, c.city, o.order_no
ORDER BY 6 DESC;


------------------------------------------------------------------------------------------------------------------------------

-- 7)
-- The top person in the company is Mr. King. 
-- He would like to see all orders in 2015 from Mexico, Germany, Canada, Belgium, Spain and Australia.
-- He would like to mail them a sales catalogue that shows all our products that can be purchaesd on line. 
-- Hopefully this will increase sales
-- Show the (1) customer number, (2)customer name (3) address1, (4) city and (5)country name 
SELECT DISTINCT
    c.cust_no,
    c.cname,
    c.address1,
    c.city,
    ct.country_name
FROM customers c
INNER JOIN countries ct ON c.country_cd = ct.country_id
INNER JOIN orders o ON c.cust_no = o.cust_no
WHERE o.channel = 'Internet Orders'
AND ct.country_name IN ( 'Mexico', 'Germany','Canada','Belgium','Spain','Australia')
AND o.order_dt BETWEEN '01-Jan-2015' AND '31-Dec-2015' ;

------------------------------------------------------------------------------------------------------------------------------

-- 8)
-- Display (1) Department_id, (2) Job_id and the (3) Lowest salary for this combination 
-- but only if that Lowest Salary falls in the range $3,000 - $12,000.??No Alias column names. 
-- Exclude people who?? 
-- (a) work as some kind of Representative (REP) job from this query and?? 
-- (b) departments IT?? -- you are given these names so must use them
-- (c) not in department 110
-- Sort the output according to the Department_id and then by Job_id.?
-- You MUST NOT use the Subquery method.?
SELECT
    d.department_id, 
    e.job_id,
    MIN(e.salary)
FROM departments d
INNER JOIN employees e ON d.department_id = e.department_id 
WHERE e.job_id NOT LIKE '%REP' 
AND d.department_name != 'IT' 
AND d.department_id != 110
GROUP BY d.department_id, e.job_id
HAVING MIN(e.salary) BETWEEN 3000 AND 12000
ORDER BY 1, 2;

------------------------------------------------------------------------------------------------------------------------------

-- 9)
-- The Marketing department wants to know of of all our customers listed in the customer table, exactly, 
-- how many customers have not placed an order? Use a sub-query
SELECT 
    count(cust_no)
FROM customers 
WHERE cust_no NOT IN (SELECT
                        cust_no
                      FROM orders);

------------------------------------------------------------------------------------------------------------------------------

-- 10)
-- Show what customers (1) number and (2) name along with the (3) country name for all customers that are in the same countries 
-- as customers starting with the name Out. Limit the list to any customer names that starts with the letters A to C. 
SELECT
    c.cust_no,
    c.cname,
    co.country_name
FROM customers c
INNER JOIN countries co ON c.country_cd = co.country_id
WHERE co.country_name IN (SELECT
                                co.country_name
                          FROM customers c
                          INNER JOIN countries co ON c.country_cd = co.country_id
                          WHERE c.cname LIKE 'Out%')
AND (UPPER(c.cname) LIKE 'A%' 
OR UPPER(c.cname) LIKE 'B%'
OR UPPER(c.cname) LIKE 'C%');


------------------------------------------------------------------------------------------------------------------------------

-- 11)
-- Original:
-- Display (1) last_name, (2) salary and (3) job ID for all employees in the US that earn more than all 
-- of the lowest paid employees in departments outside the US locations.?
-- Hint: find min(salary) in departments outside US. 
-- Then find those in the US that earn more than all the lowest paid outside of US
-- Exclude President and Vice Presidents from this query.?
-- Sort the output by job title ascending.? ?
-- You need to use a Subquery and Joining with the NEWER method. (USING/JOIN or ON)? 

SELECT
    e.last_name,
    e.salary,
    e.job_id
FROM employees e
INNER JOIN departments d ON e.department_id = d.department_id
INNER JOIN locations l ON l.location_id = d.location_id
INNER JOIN countries c ON c.country_id = l.country_id
WHERE c.country_id = 'US' 
AND ( e.job_id != 'AD_VP' AND e.job_id != 'PRES' )
AND e.salary >ALL (SELECT
                    min(salary)
                FROM employees e
                INNER JOIN departments d ON e.department_id = d.department_id
                INNER JOIN locations l ON l.location_id = d.location_id
                WHERE l.country_id != 'US' 
                GROUP BY e.department_id)
ORDER BY 3 ASC;

------------------------------------------------------------------------------------------------------------------------------

-- 12)
-- List all the last names of all the managers and list the last name of any employees they manage
SELECT 
    m.last_name,
    e.last_name       
FROM employees m
INNER JOIN employees e ON m.employee_id = e.manager_id;


------------------------------------------------------------------------------------------------------------------------------

-- 13)
-- List the last names of he managers and how many they manage. Only show those who manage more than 2.

SELECT DISTINCT    
    m.last_name,
    count(m.employee_id)
FROM employees m
INNER JOIN employees e ON m.employee_id = e.manager_id 
GROUP BY m.last_name
HAVING count(m.employee_id) > 2;


------------------------------------------------------------------------------------------------------------------------------

-- 14) 
-- The marketing people need a list of sales rep names, salary, grade letter for their salary 
-- and how much commission in dollars does each sales rep make.
-- BUT ... Only show those with total commissions earned if it is over 20,000 and the salary grade of 'C'
-- order the output by salary

SELECT 
    employee_id, 
    last_name, 
    salary, 
    grade, SUM(ol.price * ol.qty* commission_pct)
FROM employees
INNER JOIN customers ON employee_id = sales_rep
INNER JOIN orders ON customers.cust_no = orders.cust_no
INNER JOIN orderlines OL ON orders.order_no = OL.order_no
INNER JOIN job_grades ON salary between lowest_sal and highest_sal  
WHERE grade = 'C' 
GROUP BY employee_id, last_name, salary, grade
HAVING SUM(ol.price * ol.qty *commission_pct) > 20000
ORDER BY 3;
