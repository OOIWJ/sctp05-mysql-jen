create table coaches (
    coach_id int unsigned auto_increment primary key,
    first_name varchar(200) not null,
    last_name varchar(200),
    salary decimal(10,2) not null default 0,
    email varchar(500) not null
) engine = innodb;

INSERT into coaches (first_name, email) value ("David", "david@swimmingcoaches.com");

INSERT into coaches (first_name, last_name, salary, email)
value ("Tony", "Stark", 3000, "tony@swimcoached.com"),
    ("Peter", NULL, 4000, "peter@swimcoached.com"),
    ("Eddard", "Stark", 4500, "eddard@swimcoached.com");

update coaches set salary=30000 WHERE coach_id = 2;

update coaches set salary=salary*1.1 WHERE salary < 5000;

update coaches set last_name="Park", email="paterpark@swimchoaches.com"
    WHERE coach_id = 3;

delete from coaches WHERE coach_id = 4;

INSERT into coaches (first_name, email) value ("John", "johnwick@asd.com");


-- INSERT INTO: add a ew row
-- UPDATE FROM: update an existing row
-- DELETE FROM: delete an existing row