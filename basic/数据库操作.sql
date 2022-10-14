-- 查询数据库列表
show databases;

-- 创建一个名为 samp_db 的数据库，数据库字符编码指定为 gbk
create database basic_db character set gbk;

-- 选择创建的数据库samp_db
use basic_db;


-- 如果数据库中存在user_accounts表，就把它从数据库中drop掉
DROP TABLE IF EXISTS `user_accounts`;
CREATE TABLE `user_accounts` (
  `id`             int(100) unsigned NOT NULL AUTO_INCREMENT primary key,
  `password`       varchar(32)       NOT NULL DEFAULT '' COMMENT '用户密码',
  `reset_password` tinyint(32)       NOT NULL DEFAULT 0 COMMENT '用户类型：0－不需要重置密码；1-需要重置密码',
  `mobile`         varchar(20)       NOT NULL DEFAULT '' COMMENT '手机',
  `create_at`      timestamp(6)      NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `update_at`      timestamp(6)      NOT NULL DEFAULT CURRENT_TIMESTAMP(6) ON UPDATE CURRENT_TIMESTAMP(6),
  -- 创建唯一索引，不允许重复
  UNIQUE INDEX idx_user_mobile(`mobile`)
)
ENGINE=InnoDB DEFAULT CHARSET=utf8
COMMENT='用户表信息';

# 数据类型的属性解释
#
# NULL：数据列可包含NULL值；
# NOT NULL：数据列不允许包含NULL值；
# DEFAULT：默认值；
# PRIMARY KEY：主键；
# AUTO_INCREMENT：自动递增，适用于整数类型；
# UNSIGNED：是指数值类型只能为正数；
# CHARACTER SET name：指定一个字符集；
# COMMENT：对表或者字段说明；

-- 显示samp_db下面所有的表名字
show tables;

-- 显示数据表的结构
describe user_accounts;

-- 删除 库名为samp_db的库
drop database basic_db;