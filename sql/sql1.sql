-- Запуск postgres в Docker-контейнере postgres-client
-- psql --host $APP_POSTGRES_HOST -U postgres
--1. Посмотрим, водители мужчины или водители женщины чаще попадают в аварии
select sex, user_cat, count(id) as count_acc  from users_new  where user_cat=1 group by sex, user_cat;

--2. Тип ТС, который чаще всего попадает в ДТП
select cat, count(id) from vehicles_new group by cat order by count desc limit 1;

--3. Количество погибших в ДТП по годам
with cte_1 (acc_number, severity) as (select acc_number, severity from users_new where severity=2 group by severity, acc_number) select count(*), year from cte_1 left join caracteristics_new on cte_1.acc_number=caracteristics_new.acc_number group by year order by year;

--4. Общее количество погибших
with cte_2(count, year) as (with cte_1 (acc_number, severity) as (select acc_number, severity from users_new where severity=2 group by severity, acc_number) select count(*), year from cte_1 left join caracteristics_new on cte_1.acc_number=caracteristics_new.acc_number group by year) select sum(count) from cte_2;

--5. Число погибших пешеходов по годам
with cte_1 (acc_number, severity, user_cat) as (select acc_number, severity, user_cat  from users_new where severity=2 and user_cat=3 group by severity, acc_number, user_cat) select count(*), year from cte_1 left join caracteristics_new on cte_1.acc_number=caracteristics_new.acc_number group by year order by year;

--6. Департаменты, с самым большим количеством погибших за период с 2005 по 2016 
with cte_1 (acc_number, severity) as (select acc_number, severity from users_new where severity=2 group by severity, acc_number) select count(*), department from cte_1 left join caracteristics_new on cte_1.acc_number=caracteristics_new.acc_number group by department order by count desc limit 5;


--7. Количество аварий в зависимости от дорожного покрытия
select surface_cond, count(*) as num_acc from places_new group by surface_cond order by num_acc desc;

--8. Количество аварий в зависимости от погоды
select atm_cond, count(*) as num_acc from caracteristics_new group by atm_cond order by num_acc desc;


--9. Количество аварий в зависимости от освещения
select light_cond, count(*) as num_acc from caracteristics_new group by light_cond order by num_acc desc;

--10. Количество погибших на 1000 человек, участвующих в ДТП по годам
with cte_11 (count_killed, year) as (with cte_1 (acc_number, severity) as (select acc_number, severity  from users_new where severity=2  group by severity, acc_number) select count(*), year from cte_1 left join caracteristics_new on cte_1.acc_number=caracteristics_new.acc_number group by year order by year), cte_2(count, year) as (select count(*), year from caracteristics_new group by year) select (count_killed*1000/count), cte_11.year from cte_11 join cte_2 on cte_11.year=cte_2.year;



