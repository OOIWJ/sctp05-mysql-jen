-- login my sql
-- mysql -u root




-- see all the databases on your server
show databases;

-- create a new database
create database swimming_coach;

-- change the active database
use swimming_coach;

-- create a new table
-- named `parents` with some columns
-- create table <table name> (
-- <col name> <col data type> <options>
--) engine = innodb
-- The `engine = innodb` is to enable foreign keys
 
create table parents(
    parent_id int unsigned auto_increment primary key,
    first_name varchar(200) not null,
    last_name varchar(200) default '' 
) engine = innodb;  

-- show all tables
show tables;

create table students (
    student_id mediumint unsigned auto_increment primary key,
    name varchar(200) not null,
    date_of_birth datetime not null
) engine = innodb;

-- ALTER TABLE: alter an existing table
-- we can: change a column, add a new column, or delete 
ALTER TABLE students ADD COLUMN parent_id INT UNSIGNED;

-- Use DESCRIBE to show fields definition of a table
DESCRIBE students;

-- Define parent_id in students table as foreign key
ALTER TABLE students ADD CONSTRAINT fk_students_parents
FOREIGN KEY (parent_id) REFERENCES parents(parent_id);

-- ALTER TABLE: Modify an existing column
-- Let's make the parent_id foreign key in the `students` table not null
-- must provide the NEW COLUMND DEFINTION
ALTER TABLE students MODIFY COLUMN parent_id INT UNSIGNED NOT NULL;

-- Add new data
-- INSERT INTO <table name> (<col1>, col2>...) VALUES (<col1 value>, <col2 value>)
INSERT INTO parents (first_name, last_name) VALUES ("John", "Wick");

-- See all the rows from the table
-- SELECT * FROM parents --> * = all columns
SELECT * FROM parents;

-- Note: won't work because no parent_id given and parent_id is NOT NULL
--INSERT INTO students (name, date_of_birth) VALUES ("Jon Snow", "1984-06-13");

-- Note: won't work because the parent_id doesn't exist
--INSERT INTO students (name, date_of_birth, parent_id) VALUES ("Jon Snow", "1984-06-13", 99);

INSERT INTO students (name, date_of_birth, parent_id) VALUES ("Jon Snow", "1984-06-13",1);

-- DELETE: remove a row
-- the following won't work
DELETE FROM parents WHERE parent_id = 1;

-- DROP: delete an table
DROP TABLE parents; -- won't work because there's a row in students referring the row with parent_id 1

show tables;

create table payments (
    payment_id int unsigned auto_increment primary key,
    date_paid datetime not null,
    parent_id int unsigned not null,
    foreign key(parent_id) REFERENCES parents(parent_id),
    student_id mediumint unsigned not null,
    foreign key(student_id) REFERENCES students(student_id)

) engine = innodb;

alter table payments add column amount decimal(10,2);

alter table payments Modify column amount decimal (10,2) not null;

alter table payments add column test varchar(100);

alter table payments DROP column test;

show tables;
show databases;