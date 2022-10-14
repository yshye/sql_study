# 创建数据库
# create database mysql_exercise_50;
use mysql_exercise_50;

# 学生表
DROP TABLE IF EXISTS `Student`;
CREATE TABLE Student(
s_id VARCHAR(20) comment '学生id',
s_name VARCHAR(20) NOT NULL DEFAULT '' comment '学生姓名',
s_birth VARCHAR(20) NOT NULL DEFAULT '' comment '学生生日',
s_sex VARCHAR(10) NOT NULL DEFAULT '' comment '学生性别：男、女',
PRIMARY KEY(s_id)
);

# 课程表
DROP TABLE IF EXISTS `Course`;
CREATE TABLE Course(
c_id VARCHAR(20) comment '课程id',
c_name VARCHAR(20) NOT NULL DEFAULT '' comment '课程名称',
t_id VARCHAR(20) NOT NULL comment '教师id',
PRIMARY KEY(c_id)
);

# 教师表
DROP TABLE IF EXISTS `Teacher`;
CREATE TABLE Teacher(
t_id VARCHAR(20) comment '教师id',
t_name VARCHAR(20) NOT NULL DEFAULT '' comment '教师名称',
PRIMARY KEY(t_id)
);

# 成绩表
DROP TABLE IF EXISTS `Score`;
CREATE TABLE Score(
s_id VARCHAR(20) comment '学生id',
c_id VARCHAR(20) comment '课程id',
s_score INT(3) comment '学生成绩',
PRIMARY KEY(s_id,c_id)
);

show tables;
