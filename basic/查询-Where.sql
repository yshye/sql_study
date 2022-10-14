select * from persons;

select * from persons where Year > 2013;

select * from meeting;

select * from meeting where a =1 and title = 'title1';

select * from meeting where title = 'title1' or b = 1;

select * from meeting where a in (1,2);

select * from meeting order by a;
select * from meeting order by a desc ;

select * from meeting where not id = 2;

# UNION
# UNION - 操作符用于合并两个或多个 SELECT 语句的结果集。

create table Employees_China (
    E_Name  varchar(32),
    E_City varchar(32)
);
create table Employees_USA (
    E_Name  varchar(32),
    E_City varchar(32)
);

insert into Employees_China set E_Name = 'JsonYe',E_City = 'WUXI';
insert into Employees_China set E_Name = 'LiLi',E_City = 'WUXI';
insert into Employees_China set E_Name = 'RenWei',E_City = 'ShangHai';
select * from Employees_China;


insert into Employees_USA set E_Name = 'JsonYe',E_City = 'WUXI';
insert into Employees_USA set E_Name = 'AliYa',E_City = 'Ni';
insert into Employees_USA set E_Name = 'Tobe',E_City = 'Ant';
select * from Employees_USA;

-- 列出所有在中国表（Employees_China）和美国（Employees_USA）的不同的雇员名
SELECT E_Name FROM Employees_China UNION SELECT E_Name FROM Employees_USA;


select DISTINCT Address ,LastName from Persons;
