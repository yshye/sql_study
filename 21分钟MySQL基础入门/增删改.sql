use basic_db;

-- 创建示例表Persons
DROP TABLE IF EXISTS `Persons`;
create table `Persons`
(
    `Id_P`      int(100) unsigned auto_increment primary key,
    `LastName`  varchar(32),
    `Address`   varchar(32),
    `FirstName` varchar(32),
    `Year`      int(4)
);

DROP TABLE IF EXISTS `meeting`;
create table `meeting`
(
    `id`      int(4),
    `user_id` int(4),
    `title`   varchar(32),
    `a`       int(4),
    `b`       int(4)
);

DROP TABLE IF EXISTS `orders`;
create table `orders`
(
    `id`              int(4) primary key,
    `user_account_id` int(4),
    `title`           varchar(32)
);

DROP TABLE IF EXISTS `charger`;
create table `charger`
(
    `id`        int(4) primary key,
    `type`      int(4),
    `create_at` timestamp(6),
    `update_at` timestamp(6)
);

-- 插入数据
# 语法：INSERT INTO 表名称 VALUES (值1, 值2,....)
# 语法：INSERT INTO 表名称 (列1, 列2,...) VALUES (值1, 值2,....)

-- 向表 Persons 插入一条字段 LastName = JSLite 字段 Address = shanghai
INSERT INTO Persons (LastName, Address, Year)
VALUES ('JSLite', 'shanghai', 2014);
INSERT INTO Persons (LastName, Address, Year)
VALUES ('JsonYe', 'shanghai', 2015);
INSERT INTO Persons (LastName, Address, Year, FirstName)
VALUES ('Json', 'shanghai', 2016, 'Ye');
select *
from Persons;

-- 向表 meeting 插入 字段 a=1 和字段 b=2
INSERT INTO meeting
SET id=2,
    a=1,
    b=2,
    title='test2',
    user_id=2;
select *
from meeting;
--
-- SQL实现将一个表的数据插入到另外一个表的代码
-- 如果只希望导入指定字段，可以用这种方法：
-- INSERT INTO 目标表 (字段1, 字段2, ...) SELECT 字段1, 字段2, ... FROM 来源表;
INSERT INTO orders (id, user_account_id, title)
SELECT 1, m.user_id, m.title
FROM meeting m
where m.id = 1;
INSERT INTO orders (id, user_account_id, title)
SELECT 2, m.user_id, m.title
FROM meeting m
where m.id = 2;
select *
from orders;

-- 向表 charger 插入一条数据，已存在就对表 charger 更新 `type`,`update_at` 字段；
INSERT INTO `charger` (`id`, `type`, `create_at`, `update_at`)
VALUES (3, 4, '2017-05-18 11:06:17', '2017-05-18 11:06:18')
ON DUPLICATE KEY UPDATE `id`=VALUES(`id`),
                        `type`=VALUES(`type`),
                        `update_at`=VALUES(`update_at`);
select *
from charger;

# DELETE
# DELETE 语句用于删除表中的行。
# 语法：DELETE FROM 表名称 WHERE 列名称 = 值

-- 在不删除table_name表的情况下删除所有的行，清空表。
DELETE
FROM charger;
-- 删除 Person表字段 LastName = 'JSLite'
DELETE
FROM Persons
WHERE LastName = 'JSLite';
-- 删除 表meeting id 为2和3的两条数据
select *
from meeting;
DELETE
from meeting
where id in (2, 3);


# UPDATE
# Update 语句用于修改表中的数据。
# 语法：UPDATE 表名称 SET 列名称 = 新值 WHERE 列名称 = 某值

-- 更新表 orders 中 id=1 的那一行数据更新它的 title 字段
UPDATE `meeting`
set title='title1'
WHERE id = 1;
select *
from meeting
where id = 1;
update meeting
set a = 2,
    b = 4
where id = 2;


-- update语句设置字段值为另一个结果取出来的字段
update orders
set title = (select title from meeting where meeting.id = 1)
where id = (select id from meeting where meeting.title = 'title1');
select *
from orders;


