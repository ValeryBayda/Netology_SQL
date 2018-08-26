--водители мужчины или водители женщины чаще попадают в аварии
CREATE OR REPLACE VIEW accident_participant AS
select sex, user_cat, count(id) as count_acc  from users_new  where user_cat=1 group by sex, user_cat;

--Количество погибших в ДТП по годам
CREATE OR REPLACE VIEW accident_killed_by_year AS
with cte_1 (acc_number, severity) as (select acc_number, severity from users_new where severity=2 group by severity, acc_number) select count(*), year from cte_1 left join caracteristics_new on cte_1.acc_number=caracteristics_new.acc_number group by year order by year;