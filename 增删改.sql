use samp_db;

-- 创建示例表Persons
DROP TABLE IF EXISTS `Persons`;
create table `Persons`(
 `LastName` varchar(32),
 `Address` varchar(32)
);

DROP TABLE IF EXISTS `meeting`;
create table `meeting`(
    `id` int(4),
    `user_id` int(4),
    `title` varchar(32),
    `a` int(4),
    `b` int(4)
);

DROP TABLE IF EXISTS `orders`;
create table `orders`(
    `user_account_id` int(4),
    `title` varchar(32)
);

DROP TABLE IF EXISTS `charger`;
create table `charger`(
    `id` int(4) primary key ,
    `type` int(4),
    `create_at` timestamp(6),
    `update_at` timestamp(6)
);

-- 插入数据
# 语法：INSERT INTO 表名称 VALUES (值1, 值2,....)
# 语法：INSERT INTO 表名称 (列1, 列2,...) VALUES (值1, 值2,....)

-- 向表 Persons 插入一条字段 LastName = JSLite 字段 Address = shanghai
INSERT INTO Persons (LastName, Address) VALUES ('JSLite', 'shanghai');
select * from Persons;

-- 向表 meeting 插入 字段 a=1 和字段 b=2
INSERT INTO meeting SET a=1,b=2,id=1,title='test1',user_id=1;
select * from meeting;
--
-- SQL实现将一个表的数据插入到另外一个表的代码
-- 如果只希望导入指定字段，可以用这种方法：
-- INSERT INTO 目标表 (字段1, 字段2, ...) SELECT 字段1, 字段2, ... FROM 来源表;
INSERT INTO orders (user_account_id, title) SELECT m.user_id, m.title FROM meeting m where m.id=1;
select * from orders;

-- 向表 charger 插入一条数据，已存在就对表 charger 更新 `type`,`update_at` 字段；
INSERT INTO `charger` (`id`,`type`,`create_at`,`update_at`) VALUES (3,4,'2017-05-18 11:06:17','2017-05-18 11:06:18') ON DUPLICATE KEY UPDATE `id`=VALUES(`id`), `type`=VALUES(`type`), `update_at`=VALUES(`update_at`);
select * from charger;


