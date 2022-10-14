use mysql_exercise_50;

# 1、查询'01'课程比'02'课程成绩高的学生的信息及课程分数
select *
from student;
select *
from score
where c_id = '01'
   or c_id = '02';

select st.s_id, st.s_name, s.s_score as '语文', s2.s_score as '数学'
from student st
         left join score s on st.s_id = s.s_id and s.c_id = '01'
         left join score s2 on st.s_id = s2.s_id and s2.c_id = '02'
where s.s_score > s2.s_score;

# +------+--------+------------+-------+------+------+
# | s_id | s_name | s_birth    | s_sex | 语文 | 数学 |
# +------+--------+------------+-------+------+------+
# | 02   | 钱电   | 1990-12-21 | 男    |   70 |   60 |
# | 04   | 李云   | 1990-08-06 | 男    |   50 |   30 |
# +------+--------+------------+-------+------+------+

# 2、查询'01'课程比'02'课程成绩低的学生的信息及课程分数
select st.*, sc.s_score '语文', sc2.s_score '数学'
from student st
         left join score sc on sc.s_id = st.s_id and sc.c_id = '01'
         left join score sc2 on sc2.s_id = st.s_id and sc2.c_id = '02'
where sc.s_score < sc2.s_score;
# +------+--------+------------+-------+------+------+
# | s_id | s_name | s_birth    | s_sex | 语文 | 数学 |
# +------+--------+------------+-------+------+------+
# | 01   | 赵雷   | 1990-01-01 | 男    |   80 |   90 |
# | 05   | 周梅   | 1991-12-01 | 女    |   76 |   87 |
# +------+--------+------------+-------+------+------+

# 3、查询平均成绩大于等于60分的同学的学生编号和学生姓名和平均成绩
select st.s_id, st.s_name, ROUND(AVG(sc.s_score), 2) cjScore
from student st
         left join score sc on sc.s_id = st.s_id
group by st.s_id
having AVG(sc.s_score) >= 60;
# +------+--------+---------+
# | s_id | s_name | cjScore |
# +------+--------+---------+
# | 01   | 赵雷   |   89.67 |
# | 02   | 钱电   |   70.00 |
# | 03   | 孙风   |   80.00 |
# | 05   | 周梅   |   81.50 |
# | 07   | 郑竹   |   93.50 |
# +------+--------+---------+

# 4、查询平均成绩小于60分的同学的学生编号和学生姓名和平均成绩(包括有成绩的和无成绩的)
select st.s_id,
       st.s_name,
       (IF(ROUND(AVG(sc.s_score), 2) is null, 0, ROUND(AVG(sc.s_score)))) cjScore
from student st
         left join score sc on sc.s_id = st.s_id
group by st.s_id
having AVG(sc.s_score) < 60
    or AVG(sc.s_score) is NULL;
# +------+--------+---------+
# | s_id | s_name | cjScore |
# +------+--------+---------+
# | 04   | 李云   |      33 |
# | 06   | 吴兰   |      33 |
# | 08   | 王菊   |       0 |
# +------+--------+---------+

# 5、查询所有同学的学生编号、学生姓名、选课总数、所有课程的总成绩
select st.s_id,
       st.s_name,
       count(sc.c_id) as                                                         '选课总数',
       (IF(sum(sc.s_score) is null or sum(sc.s_score) = '', 0, sum(sc.s_score))) '总成绩'
from student st
         left outer join score sc on st.s_id = sc.s_id
group by st.s_id;
# +------+--------+----------+--------+
# | s_id | s_name | 选课总数 | 总成绩 |
# +------+--------+----------+--------+
# | 01   | 赵雷   |        3 |    269 |
# | 02   | 钱电   |        3 |    210 |
# | 03   | 孙风   |        3 |    240 |
# | 04   | 李云   |        3 |    100 |
# | 05   | 周梅   |        2 |    163 |
# | 06   | 吴兰   |        2 |     65 |
# | 07   | 郑竹   |        2 |    187 |
# | 08   | 王菊   |        0 |      0 |
# +------+--------+----------+--------+

# 6、查询"李"姓老师的数量
select count(*) from teacher where t_name like '李%';
# +----------+
# | count(*) |
# +----------+
# |        1 |
# +----------+

# 7、查询学过'张三'老师授课的同学的信息
select st.*
from student st
         left join score sc on sc.s_id = st.s_id
         left join course c on c.c_id = sc.c_id
         left join teacher t on t.t_id = c.t_id
where t.t_name = '张三';
#  +------+--------+------------+-------+
# | s_id | s_name | s_birth    | s_sex |
# +------+--------+------------+-------+
# | 01   | 赵雷   | 1990-01-01 | 男    |
# | 02   | 钱电   | 1990-12-21 | 男    |
# | 03   | 孙风   | 1990-05-20 | 男    |
# | 04   | 李云   | 1990-08-06 | 男    |
# | 05   | 周梅   | 1991-12-01 | 女    |
# | 07   | 郑竹   | 1989-07-01 | 女    |
# +------+--------+------------+-------+

# *8、查询没学过'张三'老师授课的同学的信息
-- 张三老师教的课
select c.*
from course c
         left join teacher t on t.t_id = c.t_id
where t.t_name = '张三';
-- 有张三老师课成绩的st.s_id
select sc.s_id
from score sc
where sc.c_id in (select c.c_id
                  from course c
                           left join teacher t on t.t_id = c.t_id
                  where t.t_name = '张三');
-- 不在上面查到的st.s_id的学生信息,即没学过张三老师授课的同学信息
select st.*
from student st
where st.s_id not in (select sc.s_id
                      from score sc
                      where sc.c_id in (select c.c_id
                                        from course c
                                                 left join teacher t on t.t_id = c.t_id
                                        where t.t_name = '张三'));
# +------+--------+------------+-------+
# | s_id | s_name | s_birth    | s_sex |
# +------+--------+------------+-------+
# | 06   | 吴兰   | 1992-03-01 | 女    |
# | 08   | 王菊   | 1990-01-20 | 女    |
# +------+--------+------------+-------+

# *9、查询学过编号为'01'并且也学过编号为'02'的课程的同学的信息
select st.*
from student st
         inner join score sc on sc.s_id = st.s_id
         inner join course c on c.c_id = sc.c_id and c.c_id = '01'
where st.s_id in (select st2.s_id
                  from student st2
                           inner join score sc2 on sc2.s_id = st2.s_id
                           inner join course c2 on c2.c_id = sc2.c_id and c2.c_id = '02');
# 或
select st.*
from student st
         inner join score s on st.s_id = s.s_id and s.c_id = '01'
         inner join score s2 on st.s_id = s2.s_id and s2.c_id = '02';
# +------+--------+------------+-------+
# | s_id | s_name | s_birth    | s_sex |
# +------+--------+------------+-------+
# | 01   | 赵雷   | 1990-01-01 | 男    |
# | 02   | 钱电   | 1990-12-21 | 男    |
# | 03   | 孙风   | 1990-05-20 | 男    |
# | 04   | 李云   | 1990-08-06 | 男    |
# | 05   | 周梅   | 1991-12-01 | 女    |
# +------+--------+------------+-------+

# 10、查询学过编号为'01'但是没有学过编号为'02'的课程的同学的信息
select st.*
from student st
         inner join score sc on sc.s_id = st.s_id
         inner join course c on c.c_id = sc.c_id and c.c_id = '01'
where st.s_id not in (select st2.s_id
                      from student st2
                               inner join score sc2 on sc2.s_id = st2.s_id
                               inner join course c2 on c2.c_id = sc2.c_id and c2.c_id = '02');
# 或
select st.*
from student st
         inner join score sc on sc.s_id = st.s_id and sc.c_id = '01'
where st.s_id not in (select st2.s_id
                      from student st2
                               inner join score sc2 on sc2.s_id = st2.s_id and sc2.c_id = '02');
# +------+--------+------------+-------+
# | s_id | s_name | s_birth    | s_sex |
# +------+--------+------------+-------+
# | 06   | 吴兰   | 1992-03-01 | 女    |
# +------+--------+------------+-------+

# 11、查询没有学全所有课程的同学的信息
select *
from student
where s_id not in (select st.s_id
                   from student st
                            inner join score sc on sc.s_id = st.s_id and sc.c_id = '01'
                   where st.s_id in (select st2.s_id
                                     from student st2
                                              inner join score sc2 on sc2.s_id = st2.s_id and sc2.c_id = '02')
                     and st.s_id in (select st2.s_id
                                     from student st2
                                              inner join score sc2 on sc2.s_id = st2.s_id and sc2.c_id = '03'));
# 或
select *
from student
where s_id not in
      (select s_id
       from score
       group by s_id
       having count(c_id) =
              (select count(*) from course));
# +------+--------+------------+-------+
# | s_id | s_name | s_birth    | s_sex |
# +------+--------+------------+-------+
# | 05   | 周梅   | 1991-12-01 | 女    |
# | 06   | 吴兰   | 1992-03-01 | 女    |
# | 07   | 郑竹   | 1989-07-01 | 女    |
# | 08   | 王菊   | 1990-01-20 | 女    |
# +------+--------+------------+-------+

# 12、查询至少有一门课与学号为'01'的同学所学相同的同学的信息
select distinct st.*
from student st
         left join score sc on sc.s_id = st.s_id
where sc.c_id in (select sc2.c_id
                  from student st2
                           left join score sc2 on sc2.s_id = st2.s_id
                  where st2.s_id = '01');
# 或
select distinct st.*
from student st
         inner join score s on st.s_id = s.s_id
where s.c_id = any (select c_id from score where s_id = '01');
# +------+--------+------------+-------+
# | s_id | s_name | s_birth    | s_sex |
# +------+--------+------------+-------+
# | 01   | 赵雷   | 1990-01-01 | 男    |
# | 02   | 钱电   | 1990-12-21 | 男    |
# | 03   | 孙风   | 1990-05-20 | 男    |
# | 04   | 李云   | 1990-08-06 | 男    |
# | 05   | 周梅   | 1991-12-01 | 女    |
# | 06   | 吴兰   | 1992-03-01 | 女    |
# | 07   | 郑竹   | 1989-07-01 | 女    |
# +------+--------+------------+-------+

# *13、查询和'01'号的同学学习的课程完全相同的其他同学的信息
select st.*
from student st
         left join score sc on sc.s_id = st.s_id
group by st.s_id
having group_concat(sc.c_id) =
       (select group_concat(sc2.c_id)
        from student st2
                 left join score sc2 on sc2.s_id = st2.s_id
        where st2.s_id = '01');
# +------+--------+------------+-------+
# | s_id | s_name | s_birth    | s_sex |
# +------+--------+------------+-------+
# | 01   | 赵雷   | 1990-01-01 | 男    |
# | 02   | 钱电   | 1990-12-21 | 男    |
# | 03   | 孙风   | 1990-05-20 | 男    |
# | 04   | 李云   | 1990-08-06 | 男    |
# +------+--------+------------+-------+

# 14、查询没学过'张三'老师讲授的任一门课程的学生姓名
select st.s_name
from student st
where st.s_id not in (select sc.s_id
                      from score sc
                               inner join course c on c.c_id = sc.c_id
                               inner join teacher t on t.t_id = c.t_id and t.t_name = '张三');
# 或
select s_name
from student
where s_id not in
      (select distinct st.s_id
       from student st
                left outer join score s on st.s_id = s.s_id
       where s.c_id in
             (select c_id
              from course
              where t_id =
                    (select t_id from teacher where t_name = '张三')));
# +--------+
# | s_name |
# +--------+
# | 吴兰   |
# | 王菊   |
# +--------+

# 15、查询两门及其以上不及格课程的同学的学号，姓名及其平均成绩
select st.s_id, st.s_name, avg(sc.s_score)
from student st
         left join score sc on sc.s_id = st.s_id
where sc.s_id in (select sc.s_id
                  from score sc
                  where sc.s_score < 60
                     or sc.s_score is NULL
                  group by sc.s_id
                  having COUNT(sc.s_id) >= 2)
group by st.s_id;
# 或
select st.s_id, st.s_name, avg(s.s_score)
from student st
         left outer join score s on st.s_id = s.s_id
where st.s_id in (select s_id
                  from score
                  where s_score < 60
                     or s_score is null
                  group by s_id
                  having count(s_score) >= 2)
group by st.s_id, st.s_name;
# +------+--------+----------------+
# | s_id | s_name | avg(s.s_score) |
# +------+--------+----------------+
# | 04   | 李云   |        33.3333 |
# | 06   | 吴兰   |        32.5000 |
# +------+--------+----------------+

# 16、检索'01'课程分数小于60，按分数降序排列的学生信息
select st.*, sc.s_score
from student st
         inner join score sc on sc.s_id = st.s_id and sc.c_id = '01' and sc.s_score < 60
order by sc.s_score desc;
# 或
select st.*, s.s_score
from student st
         inner join score s on st.s_id = s.s_id
where s.c_id = '01'
  and s.s_score < 60
order by s.s_score desc;
# +------+--------+------------+-------+---------+
# | s_id | s_name | s_birth    | s_sex | s_score |
# +------+--------+------------+-------+---------+
# | 04   | 李云   | 1990-08-06 | 男    |      50 |
# | 06   | 吴兰   | 1992-03-01 | 女    |      31 |
# +------+--------+------------+-------+---------+

# 17、按平均成绩从高到低显示所有学生的所有课程的成绩以及平均成绩，可加round,case when then else end 使显示更完美
select st.s_id, st.s_name, avg(sc4.s_score) "平均分", sc.s_score "语文", sc2.s_score '数学', sc3.s_score "英语"
from student st
         left join score sc on sc.s_id = st.s_id and sc.c_id = '01'
         left join score sc2 on sc2.s_id = st.s_id and sc2.c_id = '02'
         left join score sc3 on sc3.s_id = st.s_id and sc3.c_id = '03'
         left join score sc4 on sc4.s_id = st.s_id
group by st.s_id
order by avg(sc4.s_score) desc;
# 或
select st.s_id, st.s_name, avg(s.s_score) '平均成绩', s1.s_score '语文', s2.s_score '数学', s3.s_score '英语'
from student st
         left outer join score s on st.s_id = s.s_id
         left outer join score s1 on st.s_id = s1.s_id and s1.c_id = '01'
         left outer join score s2 on st.s_id = s2.s_id and s2.c_id = '02'
         left outer join score s3 on st.s_id = s3.s_id and s3.c_id = '03'
group by st.s_id, st.s_name
order by avg(s.s_score) desc;
# +------+--------+----------+------+------+------+
# | s_id | s_name | 平均成绩 | 语文 | 数学 | 英语 |
# +------+--------+----------+------+------+------+
# | 07   | 郑竹   |  93.5000 | NULL |   89 |   98 |
# | 01   | 赵雷   |  89.6667 |   80 |   90 |   99 |
# | 05   | 周梅   |  81.5000 |   76 |   87 | NULL |
# | 03   | 孙风   |  80.0000 |   80 |   80 |   80 |
# | 02   | 钱电   |  70.0000 |   70 |   60 |   80 |
# | 04   | 李云   |  33.3333 |   50 |   30 |   20 |
# | 06   | 吴兰   |  32.5000 |   31 | NULL |   34 |
# | 08   | 王菊   |     NULL | NULL | NULL | NULL |
# +------+--------+----------+------+------+------+

# *18.查询各科成绩最高分、最低分和平均分：以如下形式显示：课程ID，课程name，最高分，最低分，平均分，及格率，中等率，优良率，优秀率
# 及格为>=60，中等为：70-80，优良为：80-90，优秀为：>=90
select c.c_id
     , c.c_name
     , max(sc.s_score)                                       "最高分"
     , MIN(sc2.s_score)                                      "最低分"
     , avg(sc3.s_score)                                      "平均分"
     , ((select count(s_id) from score where s_score >= 60 and c_id = c.c_id) /
        (select count(s_id) from score where c_id = c.c_id)) "及格率"
     , ((select count(s_id) from score where s_score >= 70 and s_score < 80 and c_id = c.c_id) /
        (select count(s_id) from score where c_id = c.c_id)) "中等率"
     , ((select count(s_id) from score where s_score >= 80 and s_score < 90 and c_id = c.c_id) /
        (select count(s_id) from score where c_id = c.c_id)) "优良率"
     , ((select count(s_id) from score where s_score >= 90 and c_id = c.c_id) /
        (select count(s_id) from score where c_id = c.c_id)) "优秀率"
from course c
         left join score sc on sc.c_id = c.c_id
         left join score sc2 on sc2.c_id = c.c_id
         left join score sc3 on sc3.c_id = c.c_id
group by c.c_id;
# 或
select c.c_id,
       c.c_name,
       max(s.s_score)                      '最高分',
       min(s.s_score)                      '最低分',
       avg(s.s_score)                      '平均分',
       (select count(s_score) / (select count(s_score) from score where c_id = c.c_id)
        from score
        where c_id = c.c_id
          and s_score >= 60)               '及格率',
       (select count(s_score) / (select count(s_score) from score where c_id = c.c_id)
        from score
        where c_id = c.c_id
          and (s_score between 70 and 79)) '中等率',
       (select count(s_score) / (select count(s_score) from score where c_id = c.c_id)
        from score
        where c_id = c.c_id
          and (s_score between 80 and 89)) '优良率',
       (select count(s_score) / (select count(s_score) from score where c_id = c.c_id)
        from score
        where c_id = c.c_id
          and s_score >= 90)               '优秀率'
from course c
         left outer join score s on c.c_id = s.c_id
group by c.c_id, c.c_name;
# +------+--------+--------+--------+---------+--------+--------+--------+--------+
# | c_id | c_name | 最高分 | 最低分 | 平均分  | 及格率 | 中等率 | 优良率 | 优秀率 |
# +------+--------+--------+--------+---------+--------+--------+--------+--------+
# | 01   | 语文   |     80 |     31 | 64.5000 | 0.6667 | 0.3333 | 0.3333 | 0.0000 |
# | 02   | 数学   |     90 |     30 | 72.6667 | 0.8333 | 0.0000 | 0.5000 | 0.1667 |
# | 03   | 英语   |     99 |     20 | 68.5000 | 0.6667 | 0.0000 | 0.3333 | 0.3333 |
# +------+--------+--------+--------+---------+--------+--------+--------+--------+

# *19、按各科成绩进行排序，并显示排名(实现不完全)
# mysql没有rank函数
# 加@score是为了防止用union all 后打乱了顺序
select c1.s_id, c1.c_id, c1.c_name, @score := c1.s_score, @i := @i + 1
from (select c.c_name, sc.*
      from course c
               left join score sc on sc.c_id = c.c_id
      where c.c_id = '01'
      order by sc.s_score desc) c1,
     (select @i := 0) a
union all
select c2.s_id, c2.c_id, c2.c_name, c2.s_score, @ii := @ii + 1
from (select c.c_name, sc.*
      from course c
               left join score sc on sc.c_id = c.c_id
      where c.c_id = '02'
      order by sc.s_score desc) c2,
     (select @ii := 0) aa
union all
select c3.s_id, c3.c_id, c3.c_name, c3.s_score, @iii := @iii + 1
from (select c.c_name, sc.*
      from course c
               left join score sc on sc.c_id = c.c_id
      where c.c_id = '03'
      order by sc.s_score desc) c3;
set @iii = 0;
# 或
select a.*
from (select st.s_id, st.s_name, c.c_name, s.s_score, count(distinct s2.s_score) '排名'
      from score s
               inner join student st on s.s_id = st.s_id
               inner join course c on s.c_id = c.c_id,
           score s2
      where c.c_id = '01'
        and s2.s_score >= s.s_score
        and s2.c_id = '01'
      group by st.s_id, st.s_name, c.c_name, s.s_score
      order by s.s_score desc) a
union all
select b.*
from (select st.s_id, st.s_name, c.c_name, s.s_score, count(distinct s2.s_score) '排名'
      from score s
               inner join student st on s.s_id = st.s_id
               inner join course c on s.c_id = c.c_id,
           score s2
      where c.c_id = '02'
        and s2.s_score >= s.s_score
        and s2.c_id = '02'
      group by st.s_id, st.s_name, c.c_name, s.s_score
      order by s.s_score desc) b
union all
select c.*
from (select st.s_id, st.s_name, c.c_name, s.s_score, count(distinct s2.s_score) '排名'
      from score s
               inner join student st on s.s_id = st.s_id
               inner join course c on s.c_id = c.c_id,
           score s2
      where c.c_id = '03'
        and s2.s_score >= s.s_score
        and s2.c_id = '03'
      group by st.s_id, st.s_name, c.c_name, s.s_score
      order by s.s_score desc) c;
# +------+--------+--------+---------+------+
# | s_id | s_name | c_name | s_score | 排名 |
# +------+--------+--------+---------+------+
# | 01   | 赵雷   | 语文   |      80 |    1 |
# | 03   | 孙风   | 语文   |      80 |    1 |
# | 05   | 周梅   | 语文   |      76 |    2 |
# | 02   | 钱电   | 语文   |      70 |    3 |
# | 04   | 李云   | 语文   |      50 |    4 |
# | 06   | 吴兰   | 语文   |      31 |    5 |
# | 01   | 赵雷   | 数学   |      90 |    1 |
# | 07   | 郑竹   | 数学   |      89 |    2 |
# | 05   | 周梅   | 数学   |      87 |    3 |
# | 03   | 孙风   | 数学   |      80 |    4 |
# | 02   | 钱电   | 数学   |      60 |    5 |
# | 04   | 李云   | 数学   |      30 |    6 |
# | 01   | 赵雷   | 英语   |      99 |    1 |
# | 07   | 郑竹   | 英语   |      98 |    2 |
# | 02   | 钱电   | 英语   |      80 |    3 |
# | 03   | 孙风   | 英语   |      80 |    3 |
# | 06   | 吴兰   | 英语   |      34 |    4 |
# | 04   | 李云   | 英语   |      20 |    5 |
# +------+--------+--------+---------+------+

# 20、查询学生的总成绩并进行排名
select st.s_id
     , st.s_name
     , (IF(sum(sc.s_score) is null, 0, sum(sc.s_score))) as '总成绩'
from student st
         left join score sc on sc.s_id = st.s_id
group by st.s_id
order by sum(sc.s_score) desc;
# 或
select st.s_id, st.s_name, (IF(sum(s.s_score) is null, 0, sum(s.s_score))) '总成绩'
from student st
         left outer join score s on st.s_id = s.s_id
group by st.s_id, st.s_name
order by sum(s.s_score) desc;
# +------+--------+--------+
# | s_id | s_name | 总成绩 |
# +------+--------+--------+
# | 01   | 赵雷   |    269 |
# | 03   | 孙风   |    240 |
# | 02   | 钱电   |    210 |
# | 07   | 郑竹   |    187 |
# | 05   | 周梅   |    163 |
# | 04   | 李云   |    100 |
# | 06   | 吴兰   |     65 |
# | 08   | 王菊   |      0 |
# +------+--------+--------+

# 21、查询不同老师所教不同课程平均分从高到低显示
select t.t_id, t.t_name, c.c_name, avg(sc.s_score)
from teacher t
         left join course c on c.t_id = t.t_id
         left join score sc on sc.c_id = c.c_id
group by t.t_id
order by avg(sc.s_score) desc;
# 或
select t.t_id, t.t_name, c.c_name, avg(s.s_score) '平均分'
from teacher t
         left outer join course c on t.t_id = c.t_id
         left outer join score s on c.c_id = s.c_id
group by t.t_id, t.t_name, c.c_name
order by avg(s.s_score) desc;
# +------+--------+--------+---------+
# | t_id | t_name | c_name | 平均分  |
# +------+--------+--------+---------+
# | 01   | 张三   | 数学   | 72.6667 |
# | 03   | 王五   | 英语   | 68.5000 |
# | 02   | 李四   | 语文   | 64.5000 |
# +------+--------+--------+---------+

# 22、查询所有课程的成绩第2名到第3名的学生信息及该课程成绩
select st.*, c.c_name, s.s_score
from student st
         left join score s on st.s_id = s.s_id
         left join course c on s.c_id = c.c_id
where s.c_id = '01'
  and (
    s.s_score between
        (select distinct a.s_score
         from (select s.s_score, count(distinct s2.s_score) '排名'
               from score s
                        inner join student st on s.s_id = st.s_id
                        inner join course c on s.c_id = c.c_id,
                    score s2
               where c.c_id = '01'
                 and s2.s_score >= s.s_score
                 and s2.c_id = '01'
               group by st.s_id, st.s_name, c.c_name, s.s_score
               order by s.s_score desc) a
         where a.排名 = 3)
        and
        (select distinct a.s_score
         from (select s.s_score, count(distinct s2.s_score) '排名'
               from score s
                        inner join student st on s.s_id = st.s_id
                        inner join course c on s.c_id = c.c_id,
                    score s2
               where c.c_id = '01'
                 and s2.s_score >= s.s_score
                 and s2.c_id = '01'
               group by st.s_id, st.s_name, c.c_name, s.s_score
               order by s.s_score desc) a
         where a.排名 = 2)
    )
union all
select st.*, c.c_name, s.s_score
from student st
         left join score s on st.s_id = s.s_id
         left join course c on s.c_id = c.c_id
where s.c_id = '02'
  and (
    s.s_score between
        (select distinct a.s_score
         from (select s.s_score, count(distinct s2.s_score) '排名'
               from score s
                        inner join student st on s.s_id = st.s_id
                        inner join course c on s.c_id = c.c_id,
                    score s2
               where c.c_id = '02'
                 and s2.s_score >= s.s_score
                 and s2.c_id = '02'
               group by st.s_id, st.s_name, c.c_name, s.s_score
               order by s.s_score desc) a
         where a.排名 = 3)
        and
        (select distinct a.s_score
         from (select s.s_score, count(distinct s2.s_score) '排名'
               from score s
                        inner join student st on s.s_id = st.s_id
                        inner join course c on s.c_id = c.c_id,
                    score s2
               where c.c_id = '02'
                 and s2.s_score >= s.s_score
                 and s2.c_id = '02'
               group by st.s_id, st.s_name, c.c_name, s.s_score
               order by s.s_score desc) a
         where a.排名 = 2)
    )
union all
select st.*, c.c_name, s.s_score
from student st
         left join score s on st.s_id = s.s_id
         left join course c on s.c_id = c.c_id
where s.c_id = '03'
  and (
    s.s_score between
        (select distinct a.s_score
         from (select s.s_score, count(distinct s2.s_score) '排名'
               from score s
                        inner join student st on s.s_id = st.s_id
                        inner join course c on s.c_id = c.c_id,
                    score s2
               where c.c_id = '03'
                 and s2.s_score >= s.s_score
                 and s2.c_id = '03'
               group by st.s_id, st.s_name, c.c_name, s.s_score
               order by s.s_score desc) a
         where a.排名 = 3)
        and
        (select distinct a.s_score
         from (select s.s_score, count(distinct s2.s_score) '排名'
               from score s
                        inner join student st on s.s_id = st.s_id
                        inner join course c on s.c_id = c.c_id,
                    score s2
               where c.c_id = '03'
                 and s2.s_score >= s.s_score
                 and s2.c_id = '03'
               group by st.s_id, st.s_name, c.c_name, s.s_score
               order by s.s_score desc) a
         where a.排名 = 2)
    );
# +------+--------+------------+-------+--------+---------+
# | s_id | s_name | s_birth    | s_sex | c_name | s_score |
# +------+--------+------------+-------+--------+---------+
# | 02   | 钱电   | 1990-12-21 | 男    | 语文   |      70 |
# | 05   | 周梅   | 1991-12-01 | 女    | 语文   |      76 |
# | 05   | 周梅   | 1991-12-01 | 女    | 数学   |      87 |
# | 07   | 郑竹   | 1989-07-01 | 女    | 数学   |      89 |
# | 02   | 钱电   | 1990-12-21 | 男    | 英语   |      80 |
# | 03   | 孙风   | 1990-05-20 | 男    | 英语   |      80 |
# | 07   | 郑竹   | 1989-07-01 | 女    | 英语   |      98 |
# +------+--------+------------+-------+--------+---------+

# *23、统计各科成绩各分数段人数：课程编号,课程名称,[100-85],[85-70],[70-60],[60-0]及所占百分比
select c.c_id
     , c.c_name
     , ((select count(1) from score sc where sc.c_id = c.c_id and sc.s_score <= 100 and sc.s_score > 80) /
        (select count(1) from score sc where sc.c_id = c.c_id)) "100-85"
     , ((select count(1) from score sc where sc.c_id = c.c_id and sc.s_score <= 85 and sc.s_score > 70) /
        (select count(1) from score sc where sc.c_id = c.c_id)) "85-70"
     , ((select count(1) from score sc where sc.c_id = c.c_id and sc.s_score <= 70 and sc.s_score > 60) /
        (select count(1) from score sc where sc.c_id = c.c_id)) "70-60"
     , ((select count(1) from score sc where sc.c_id = c.c_id and sc.s_score <= 60 and sc.s_score >= 0) /
        (select count(1) from score sc where sc.c_id = c.c_id)) "60-0"
from course c
order by c.c_id;
# +------+--------+--------+--------+--------+--------+
# | c_id | c_name | 100-85 | 85-70  | 70-60  | 60-0   |
# +------+--------+--------+--------+--------+--------+
# | 01   | 语文   | 0.0000 | 0.5000 | 0.1667 | 0.3333 |
# | 02   | 数学   | 0.5000 | 0.1667 | 0.0000 | 0.3333 |
# | 03   | 英语   | 0.3333 | 0.3333 | 0.0000 | 0.3333 |
# +------+--------+--------+--------+--------+--------+
# --count(1) 会统计表中的所有的记录数，包含字段为null 的记录。
# --count(字段) 会统计该字段在表中出现的次数，忽略字段为null 的情况。即不统计字段为null 的记录。

# 24、查询学生平均成绩及其名次
set @i = 0; -- 推荐
select a.*, @i := @i + 1 as '名次'
from (select st.s_id, st.s_name, round((IF(avg(sc.s_score) is null, 0, avg(sc.s_score))), 2) "平均成绩"
      from student st
               left join score sc on sc.s_id = st.s_id
      group by st.s_id) a
      order by a.平均成绩 desc;
# 或
select a.*, count(distinct b.平均成绩) '名次'
from (select st.s_id, st.s_name, (IF(avg(s.s_score) is null, 0, avg(s.s_score))) '平均成绩'
      from student st
               left join score s on st.s_id = s.s_id
      group by st.s_id, st.s_name) a,
     (select st.s_id, (IF(avg(s.s_score) is null, 0, avg(s.s_score))) '平均成绩'
      from student st
               left join score s on st.s_id = s.s_id
      group by st.s_id) b
where a.平均成绩 <= b.平均成绩
group by a.s_id
order by a.平均成绩 desc;
# +------+--------+----------+------+
# | s_id | s_name | 平均成绩 | 名次 |
# +------+--------+----------+------+
# | 07   | 郑竹   |  93.5000 |    1 |
# | 01   | 赵雷   |  89.6667 |    2 |
# | 05   | 周梅   |  81.5000 |    3 |
# | 03   | 孙风   |  80.0000 |    4 |
# | 02   | 钱电   |  70.0000 |    5 |
# | 04   | 李云   |  33.3333 |    6 |
# | 06   | 吴兰   |  32.5000 |    7 |
# | 08   | 王菊   |   0.0000 |    8 |
# +------+--------+----------+------+

# 25、查询各科成绩前三名的记录
select a.*
from (select st.*, c.c_name, s.s_score
      from student st
               left join score s on st.s_id = s.s_id
               left join course c on c.c_id = s.c_id
      where c.c_id = '01'
        and s.s_score between (select distinct a1.s_score
                               from (select a2.s_id, a2.s_score, count(distinct a3.s_score) '名次'
                                     from score a2,
                                          score a3
                                     where a2.c_id = '01'
                                       and a3.c_id = '01'
                                       and a2.s_score <= a3.s_score
                                     group by a2.s_id, a2.s_score) a1
                               where a1.名次 = 3)
          and
              (select max(s_score) from score where c_id = '01')) a
union all
select b.*
from (select st.*, c.c_name, s.s_score
      from student st
               left join score s on st.s_id = s.s_id
               left join course c on c.c_id = s.c_id
      where c.c_id = '02'
        and s.s_score between (select distinct a1.s_score
                               from (select a2.s_id, a2.s_score, count(distinct a3.s_score) '名次'
                                     from score a2,
                                          score a3
                                     where a2.c_id = '02'
                                       and a3.c_id = '02'
                                       and a2.s_score <= a3.s_score
                                     group by a2.s_id, a2.s_score) a1
                               where a1.名次 = 3)
          and
              (select max(s_score) from score where c_id = '02')) b
union all
select c.*
from (select st.*, c.c_name, s.s_score
      from student st
               left join score s on st.s_id = s.s_id
               left join course c on c.c_id = s.c_id
      where c.c_id = '03'
        and s.s_score between (select distinct a1.s_score
                               from (select a2.s_id, a2.s_score, count(distinct a3.s_score) '名次'
                                     from score a2,
                                          score a3
                                     where a2.c_id = '03'
                                       and a3.c_id = '03'
                                       and a2.s_score <= a3.s_score
                                     group by a2.s_id, a2.s_score) a1
                               where a1.名次 = 3)
          and
              (select max(s_score) from score where c_id = '03')) c;
# +------+--------+------------+-------+--------+---------+
# | s_id | s_name | s_birth    | s_sex | c_name | s_score |
# +------+--------+------------+-------+--------+---------+
# | 01   | 赵雷   | 1990-01-01 | 男    | 语文   |      80 |
# | 02   | 钱电   | 1990-12-21 | 男    | 语文   |      70 |
# | 03   | 孙风   | 1990-05-20 | 男    | 语文   |      80 |
# | 05   | 周梅   | 1991-12-01 | 女    | 语文   |      76 |
# | 01   | 赵雷   | 1990-01-01 | 男    | 数学   |      90 |
# | 05   | 周梅   | 1991-12-01 | 女    | 数学   |      87 |
# | 07   | 郑竹   | 1989-07-01 | 女    | 数学   |      89 |
# | 01   | 赵雷   | 1990-01-01 | 男    | 英语   |      99 |
# | 02   | 钱电   | 1990-12-21 | 男    | 英语   |      80 |
# | 03   | 孙风   | 1990-05-20 | 男    | 英语   |      80 |
# | 07   | 郑竹   | 1989-07-01 | 女    | 英语   |      98 |
# +------+--------+------------+-------+--------+---------+

# 26、查询每门课程被选修的学生数
select c.c_id, c.c_name, count(1) '选修人数'
from course c
         left join score sc on sc.c_id = c.c_id
         inner join student st on st.s_id = c.c_id -- ？？？
group by st.s_id;
# 或
select c.c_id, c.c_name, count(s.s_id) '选修人数'
from course c
         left join score s on c.c_id = s.c_id
group by c.c_id, c.c_name;
# +------+--------+----------+
# | c_id | c_name | 选修人数 |
# +------+--------+----------+
# | 01   | 语文   |        6 |
# | 02   | 数学   |        6 |
# | 03   | 英语   |        6 |
# +------+--------+----------+

# 27、查询出只有两门课程的全部学生的学号和姓名
select st.s_id, st.s_name
from student st
         left join score sc on sc.s_id = st.s_id
         inner join course c on c.c_id = sc.c_id
group by st.s_id
having count(1) = 2;
# 或
select st.s_id, st.s_name
from student st
         left join score s on st.s_id = s.s_id
group by st.s_id, st.s_name
having count(s.c_id) = 2;
# +------+--------+
# | s_id | s_name |
# +------+--------+
# | 05   | 周梅   |
# | 06   | 吴兰   |
# | 07   | 郑竹   |
# +------+--------+

# 28、查询男生、女生人数
select st.s_sex, count(1)
from student st
group by st.s_sex;
# +-------+----------+
# | s_sex | count(1) |
# +-------+----------+
# | 男    |        4 |
# | 女    |        4 |
# +-------+----------+

# 29、查询名字中含有"风"字的学生信息
select st.*
from student st
where st.s_name like '%风%';
# +------+--------+------------+-------+
# | s_id | s_name | s_birth    | s_sex |
# +------+--------+------------+-------+
# | 03   | 孙风   | 1990-05-20 | 男    |
# +------+--------+------------+-------+

# 30、查询同名同性学生名单，并统计同名人数
select st.*, count(1)
from student st
group by st.s_name, st.s_sex
having count(1) > 1;


# 31、查询1990年出生的学生名单
select st.*
from student st
where st.s_birth like '1990%';
# 或
select *
from student
where year(s_birth) = '1990';
# +------+--------+------------+-------+
# | s_id | s_name | s_birth    | s_sex |
# +------+--------+------------+-------+
# | 01   | 赵雷   | 1990-01-01 | 男    |
# | 02   | 钱电   | 1990-12-21 | 男    |
# | 03   | 孙风   | 1990-05-20 | 男    |
# | 04   | 李云   | 1990-08-06 | 男    |
# | 08   | 王菊   | 1990-01-20 | 女    |
# +------+--------+------------+-------+

# 32、查询每门课程的平均成绩，结果按平均成绩降序排列，平均成绩相同时，按课程编号升序排列
select c.c_id, c.c_name, avg(sc.s_score)
from course c
         inner join score sc on sc.c_id = c.c_id
group by c.c_id, c.c_name
order by avg(sc.s_score) desc, c.c_id;
# +------+--------+-----------------+
# | c_id | c_name | avg(sc.s_score) |
# +------+--------+-----------------+
# | 02   | 数学   |         72.6667 |
# | 03   | 英语   |         68.5000 |
# | 01   | 语文   |         64.5000 |
# +------+--------+-----------------+

# 33、查询平均成绩大于等于85的所有学生的学号、姓名和平均成绩
select st.s_id, st.s_name, avg(sc.s_score)
from student st
         left join score sc on sc.s_id = st.s_id
group by st.s_id
having avg(sc.s_score) >= 85;
# +------+--------+-----------------+
# | s_id | s_name | avg(sc.s_score) |
# +------+--------+-----------------+
# | 01   | 赵雷   |         89.6667 |
# | 07   | 郑竹   |         93.5000 |
# +------+--------+-----------------+

# 34、查询课程名称为'数学'，且分数低于60的学生姓名和分数
select st.s_name, sc.s_score
from student st
         inner join score sc on sc.s_id = st.s_id and sc.s_score < 60
         inner join course c on c.c_id = sc.c_id and c.c_name = '数学';
# 或
select st.s_name, s.s_score
from student st
         left join score s on st.s_id = s.s_id
         left join course c on c.c_id = s.c_id
where c.c_name = '数学'
  and s.s_score < 60;
# +--------+---------+
# | s_name | s_score |
# +--------+---------+
# | 李云   |      30 |
# +--------+---------+

# 35、查询所有学生的课程及分数情况；
select st.s_id, st.s_name, c.c_name, sc.s_score
from student st
         left join score sc on sc.s_id = st.s_id
         left join course c on c.c_id = sc.c_id
order by st.s_id, c.c_name;
# +------+--------+--------+---------+
# | s_id | s_name | c_name | s_score |
# +------+--------+--------+---------+
# | 01   | 赵雷   | 数学   |      90 |
# | 01   | 赵雷   | 英语   |      99 |
# | 01   | 赵雷   | 语文   |      80 |
# | 02   | 钱电   | 数学   |      60 |
# | 02   | 钱电   | 英语   |      80 |
# | 02   | 钱电   | 语文   |      70 |
# | 03   | 孙风   | 数学   |      80 |
# | 03   | 孙风   | 英语   |      80 |
# | 03   | 孙风   | 语文   |      80 |
# | 04   | 李云   | 数学   |      30 |
# | 04   | 李云   | 英语   |      20 |
# | 04   | 李云   | 语文   |      50 |
# | 05   | 周梅   | 数学   |      87 |
# | 05   | 周梅   | 语文   |      76 |
# | 06   | 吴兰   | 英语   |      34 |
# | 06   | 吴兰   | 语文   |      31 |
# | 07   | 郑竹   | 数学   |      89 |
# | 07   | 郑竹   | 英语   |      98 |
# | 08   | 王菊   | NULL   |    NULL |
# +------+--------+--------+---------+

# 36、查询任何一门课程成绩在70分以上的姓名、课程名称和分数
select st2.s_id, st2.s_name, c2.c_name, sc2.s_score
from student st2
         left join score sc2 on sc2.s_id = st2.s_id
         left join course c2 on c2.c_id = sc2.c_id
where st2.s_id in (select st.s_id
                   from student st
                            left join score sc on sc.s_id = st.s_id
                   group by st.s_id
                   having min(sc.s_score) > 70)
order by s_id;
# +------+--------+--------+---------+
# | s_id | s_name | c_name | s_score |
# +------+--------+--------+---------+
# | 01   | 赵雷   | 语文   |      80 |
# | 01   | 赵雷   | 数学   |      90 |
# | 01   | 赵雷   | 英语   |      99 |
# | 03   | 孙风   | 语文   |      80 |
# | 03   | 孙风   | 数学   |      80 |
# | 03   | 孙风   | 英语   |      80 |
# | 05   | 周梅   | 语文   |      76 |
# | 05   | 周梅   | 数学   |      87 |
# | 07   | 郑竹   | 数学   |      89 |
# | 07   | 郑竹   | 英语   |      98 |
# +------+--------+--------+---------+

# 37、查询不及格的课程
select st.s_id, c.c_name, st.s_name, sc.s_score
from student st
         inner join score sc on sc.s_id = st.s_id and sc.s_score < 60
         inner join course c on c.c_id = sc.c_id;
# 或
select st.s_id, st.s_name, c.c_name, s.s_score
from student st
         left join score s on s.s_id = st.s_id
         left join course c on c.c_id = s.c_id
where s.s_score < 60;
# +------+--------+--------+---------+
# | s_id | c_name | s_name | s_score |
# +------+--------+--------+---------+
# | 04   | 语文   | 李云   |      50 |
# | 04   | 数学   | 李云   |      30 |
# | 04   | 英语   | 李云   |      20 |
# | 06   | 语文   | 吴兰   |      31 |
# | 06   | 英语   | 吴兰   |      34 |
# +------+--------+--------+---------+

# 38、查询课程编号为01且课程成绩在80分以上的学生的学号和姓名
select st.s_id, st.s_name, sc.s_score
from student st
         inner join score sc on sc.s_id = st.s_id and sc.c_id = '01' and sc.s_score >= 80;
# +------+--------+---------+
# | s_id | s_name | s_score |
# +------+--------+---------+
# | 01   | 赵雷   |      80 |
# | 03   | 孙风   |      80 |
# +------+--------+---------+

# 39、求每门课程的学生人数
select c.c_id, c.c_name, count(1)
from course c
         inner join score sc on sc.c_id = c.c_id
group by c.c_id;
# 或
select c.c_id, c.c_name, count(st.s_id)
from course c
         left join score s on c.c_id = s.c_id
         left join student st on s.s_id = st.s_id
group by c.c_id, c.c_name;
# +------+--------+----------------+
# | c_id | c_name | count(st.s_id) |
# +------+--------+----------------+
# | 01   | 语文   |              6 |
# | 02   | 数学   |              6 |
# | 03   | 英语   |              6 |
# +------+--------+----------------+

# 40、查询选修'张三'老师所授课程的学生中，成绩最高的学生信息及其成绩
select st.*, c.c_name, sc.s_score, t.t_name
from student st
         inner join score sc on sc.s_id = st.s_id
         inner join course c on c.c_id = sc.c_id
         inner join teacher t on t.t_id = c.t_id and t.t_name = '张三'
order by sc.s_score desc
limit 0,1;
# 或
select st.*, s.s_score, t.t_name, c.c_name
from student st
         left join score s on st.s_id = s.s_id
         left join course c on s.c_id = c.c_id
         left join teacher t on c.t_id = t.t_id
where t.t_name = '张三'
  and s.s_score = (select distinct max(s2.s_score)
                   from score s2
                            left join course c2 on s2.c_id = c2.c_id
                            left join teacher t2 on c2.t_id = t2.t_id
                   where t2.t_name = '张三');
# +------+--------+------------+-------+---------+--------+--------+
# | s_id | s_name | s_birth    | s_sex | s_score | t_name | c_name |
# +------+--------+------------+-------+---------+--------+--------+
# | 01   | 赵雷   | 1990-01-01 | 男    |      90 | 张三   | 数学   |
# +------+--------+------------+-------+---------+--------+--------+

# *41、查询不同课程成绩相同的学生的学生编号、课程编号、学生成绩
select st.s_id, st.s_name, sc.c_id, sc.s_score, c.c_name
from student st
         left join score sc on sc.s_id = st.s_id
         left join course c on c.c_id = sc.c_id
where (select count(1)
       from student st2
                left join score sc2 on sc2.s_id = st2.s_id
                left join course c2 on c2.c_id = sc2.c_id
       where sc.s_score = sc2.s_score
         and c.c_id != c2.c_id) > 1;

# 42、查询每门功成绩最好的前两名
select a.*
from (select st.s_id, st.s_name, c.c_name, sc.s_score
      from student st
               left join score sc on sc.s_id = st.s_id
               inner join course c on c.c_id = sc.c_id and c.c_id = '01'
      order by sc.s_score desc
      limit 0,2) a
union all
select b.*
from (select st.s_id, st.s_name, c.c_name, sc.s_score
      from student st
               left join score sc on sc.s_id = st.s_id
               inner join course c on c.c_id = sc.c_id and c.c_id = '02'
      order by sc.s_score desc
      limit 0,2) b
union all
select c.*
from (select st.s_id, st.s_name, c.c_name, sc.s_score
      from student st
               left join score sc on sc.s_id = st.s_id
               inner join course c on c.c_id = sc.c_id and c.c_id = '03'
      order by sc.s_score desc
      limit 0,2) c;
# +------+--------+--------+---------+
# | s_id | s_name | c_name | s_score |
# +------+--------+--------+---------+
# | 01   | 赵雷   | 语文   |      80 |
# | 03   | 孙风   | 语文   |      80 |
# | 01   | 赵雷   | 数学   |      90 |
# | 07   | 郑竹   | 数学   |      89 |
# | 01   | 赵雷   | 英语   |      99 |
# | 07   | 郑竹   | 英语   |      98 |
# +------+--------+--------+---------+
-- 借鉴(更准确,漂亮):
select a.s_id, a.c_id, a.s_score
from score a
where (select COUNT(1) from score b where b.c_id = a.c_id and b.s_score >= a.s_score) <= 2
order by a.c_id;


# 43、统计每门课程的学生选修人数（超过5人的课程才统计）。要求输出课程号和选修人数，查询结果按人数降序排列，若人数相同，按课程号升序排列
select sc.c_id, count(1)
from score sc
         left join course c on c.c_id = sc.c_id
group by sc.c_id
having count(1) > 5
order by count(1) desc, sc.c_id;
# 或
select c.c_id, count(s.s_id)
from course c
         left join score s on c.c_id = s.c_id
group by c.c_id
having count(s.s_id) > 5
order by count(s.s_id) desc, c.c_id;
# +------+---------------+
# | c_id | count(s.s_id) |
# +------+---------------+
# | 01   |             6 |
# | 02   |             6 |
# | 03   |             6 |
# +------+---------------+

# 44、检索至少选修两门课程的学生学号
select st.s_id
from student st
         left join score sc on sc.s_id = st.s_id
group by st.s_id
having count(1) >= 2;
# +------+
# | s_id |
# +------+
# | 01   |
# | 02   |
# | 03   |
# | 04   |
# | 05   |
# | 06   |
# | 07   |
# +------+

# 45、查询选修了全部课程的学生信息
select st.*
from student st
         left join score s on st.s_id = s.s_id
group by st.s_id
having count(s.c_id) = (select count(*) from course);
# +------+--------+------------+-------+
# | s_id | s_name | s_birth    | s_sex |
# +------+--------+------------+-------+
# | 01   | 赵雷   | 1990-01-01 | 男    |
# | 02   | 钱电   | 1990-12-21 | 男    |
# | 03   | 孙风   | 1990-05-20 | 男    |
# | 04   | 李云   | 1990-08-06 | 男    |
# +------+--------+------------+-------+

# *46、查询各学生的年龄(实岁)
select st.*, timestampdiff(year, st.s_birth, now())
from student st;

# 47、查询本周过生日的学生
select st.*
from student st
where week(now()) = week(date_format(st.s_birth, '%Y%m%d'));

# 48、查询下周过生日的学生(还要排除闰年情况)
select st.*
from student st
where week(now()) + 1 = week(date_format(st.s_birth, '%Y%m%d'));

# 49、查询本月过生日的学生
select st.*
from student st
where month(now()) = month(date_format(st.s_birth, '%Y%m%d'));

# *50、查询下月过生日的学生
# 注意:当 当前月为12时,用month(now())+1为13而不是1,可用timestampadd()函数或mod取模
select st.*
from student st
where month(timestampadd(month, 1, now())) = month(date_format(st.s_birth, '%Y%m%d'));
-- 或
select st.*
from student st
where (month(now()) + 1) mod 12 = month(date_format(st.s_birth, '%Y%m%d'));
