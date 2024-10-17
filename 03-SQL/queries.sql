SELECT * from employees;
select * from employees where officeCode = 1;
select * from employees where reportsTo = 1143;
select officeCode, firstName, lastName, email from employees where officeCode = 1;

select * from customers;
select customerNumber, customerName, contactLastName, contactFirstName, country FROM customers where country = "USA";
select * from customers where country = "USA" OR country ="France";
select * from customers where (country= "USA" or country ="France") and creditLimit>=50000;

SELECT * from employees;
SELECT * from employees where jobTitle like "%sales";
SELECT * from employees where jobTitle like "sales%";
SELECT * from employees where jobTitle like "%sales%";

select * from employees;
select * from employees join offices on employees.officeCode = offices.officeCode;
select firstName, lastName, country, city from employees join offices 
	on employees.officeCode = offices.officeCode where country = "USA";

select firstName, lastName, country, city from employees join offices 
	on employees.officeCode = offices.officeCode where country = "USA"; 

select supervised_firstName, supervised_lastName, supervised_employees,
	from employees AS supervised_employees

SELECT * from customers join employees
	on customers.salesRepEmployeeNumber = employees.employeeNumber
	join offices
	on employees.officeCode = offices.officeCode;
	
SELECT customerName, employees.firstName, employees.lastName, offices.country, offices.city 
	from customers join employees
	on customers.salesRepEmployeeNumber = employees.employeeNumber
	join offices
	on employees.officeCode = offices.officeCode;
	
SELECT customerName, e.firstName, e.lastName, o.country, o.city 
	from customers AS c join employees  AS e
	on c.salesRepEmployeeNumber = e.employeeNumber
	join offices as o
	on e.officeCode = o.officeCode;

SELECT customerName, e.firstName, e.lastName, o.country, o.city 
	from customers AS c join employees  AS e
	on c.salesRepEmployeeNumber = e.employeeNumber
	join offices as o
	on e.officeCode = o.officeCode;

-- ---------------------orders -------------------------------
select * from orders;

select orderNumber, status, comments from orders where 
	status != "Shipped" and comments like "%complaint%";

select orderNumber, status, comments, orders.customerNumber, customers.customerName from orders
	join customers 
	on orders.customerNumber = customers.customerNumber
	where 
		status != "Shipped" AND 
		(comments like "%complaint%" or comments like "%complain%" or comments like "%dispute%");

select * from customers left join employees 
on customers.salesRepEmployeeNumber = employees.employeeNumber;

-- --------------date-------------------
describe orders;

select * from orders where orderDate < "2004-01-01";

select * from orders where orderDate >= "2003-06-01" and orderDate <= "2003-06-31";

select * from orders where orderDate between "2003-06-01" and "2003-06-31";

select orderNumber, year(orderDate), month(orderDate), day(orderDate) from orders;

select orderNumber, orderDate from orders where year(orderDate)=2003 and month(orderDate)=6;

select orderNumber, orderDate, date_add(orderDate, interval 14 day) from orders;

select * from orders where shippedDate > requiredDate;

select orderNumber, requiredDate, shippedDate, shippedDate - requiredDate as "Day Late By" 
	from orders where shippedDate > requiredDate;

-- ---------Aggregate ------------------
SELECT * FROM customers;
SELECT sum(creditLimit) FROM customers ;
SELECT avg(creditLimit) FROM customers ;
SELECT min(creditLimit) FROM customers ;
SELECT max(creditLimit) FROM customers ;
SELECT min(creditLimit) FROM customers where creditLimit > 0;
SELECT sum(amount) FROM payments where customerNumber = 112;
SELECT count(*) FROM employees;
select officeCode from employees;
select distinct officeCode from employees;
select count(*) from employees where officeCode = 2;

-- ------Group by ------
SELECT officeCode, count(*) FROM employees
    group by officeCode;

-- count how many customers for each country
SELECT country, count(*) FROM customers
	group by country

-- for every customer, how must they paid on
SELECT customerNumber, sum(amount) FROM payments
	group by customerNumber
	having sum(amount) > 50000

SELECT customerNumber, sum(amount) as `Total Paid` FROM payments
	group by customerNumber
	having `Total Paid` > 50000

SELECT customerName, payments.customerNumber, sum(amount) as `Total Paid` FROM payments
	join customers on payments.customerNumber = customers.customerNumber
	group by payments.customerNumber, customerName
	having `Total Paid` > 50000

-- ---add where, add before group by and/or after join order----
SELECT customerName, payments.customerNumber, sum(amount) as `Total Paid` FROM payments
	join customers on payments.customerNumber = customers.customerNumber
	where country = "USA"
	group by payments.customerNumber, customerName
	having `Total Paid` > 50000

-- --- add descending, add at 2nd last order------
SELECT customerName, payments.customerNumber, sum(amount) as `Total Paid` FROM payments
	join customers on payments.customerNumber = customers.customerNumber
	where country = "USA"
	group by payments.customerNumber, customerName
	having `Total Paid` > 50000
	order by `Total Paid`desc

-- ---add limit (limit in first 10 result), add at last order-----
SELECT customerName, payments.customerNumber, sum(amount) as `Total Paid` FROM payments
	join customers on payments.customerNumber = customers.customerNumber
	where country = "USA"
	group by payments.customerNumber, customerName
	having `Total Paid` > 50000
	order by `Total Paid`desc
	limit 10; 