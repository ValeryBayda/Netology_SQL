

import pandas as pd
import numpy as np
import psycopg2
import os

params = {
    "host": os.environ['APP_POSTGRES_HOST'],
    "port": os.environ['APP_POSTGRES_PORT'],
    "user": 'postgres'
}
conn = psycopg2.connect(**params)
psycopg2.extensions.register_type(
    psycopg2.extensions.UNICODE,
    conn
)
conn.set_isolation_level(
    psycopg2.extensions.ISOLATION_LEVEL_AUTOCOMMIT
)
cursor = conn.cursor()

users="select * from users_new"
caracteristics="select * from caracteristics_new"
vehicles="select * from vehicles_new"
places="select * from places_new"
#создаем объект users
cursor.execute(users)
users=pd.DataFrame([a for a in cursor.fetchall()], columns=['id', 'acc_number', 'user_cat', 'severity', 'sex', 'secu', 'year_birth'])
conn.commit()
users.head()

#создаем объект caracteristics
cursor.execute(caracteristics)
caracteristics=pd.DataFrame([a for a in cursor.fetchall()], columns=['id', 'acc_number', 'year', 'month', 'day', 'hour', 'light_cond', 'atm_cond', 'department'])
conn.commit()
caracteristics.head()

#создаем объект places
cursor.execute(places)
places=pd.DataFrame([a for a in cursor.fetchall()], columns=['id', 'acc_number', 'road_cat', 'traffic_type', 'number_lines', 'surface_cond', 'infra', 'situation'])
conn.commit()
places.head()

#создаем объект vehicles
cursor.execute(vehicles)
vehicles=pd.DataFrame([a for a in cursor.fetchall()], columns=['id', 'acc_number', 'cat'])
conn.commit()
vehicles.head()

#--1. Посмотрим, водители мужчины или водители женщины чаще попадают в аварии
#select sex, user_cat, count(id) as count_acc  from users_new  where user_cat=1 group by sex, user_cat;
df1=users.loc[users['user_cat']==1].groupby('sex')['acc_number'].count()
df1.to_csv('data.csv', encoding='utf-8')
df1

#--2. Количество погибших в ДТП по годам
#with cte_1 (acc_number, severity) as (select acc_number, severity from users_new where severity=2 group by severity, acc_number) select count(*), year from cte_1 left join caracteristics_new on cte_1.acc_number=caracteristics_new.acc_number group by year order by year;
df=users.merge(caracteristics, how='inner', left_on='acc_number', right_on='acc_number')
df.loc[df['severity']==2].groupby('year')['acc_number'].count()
df
#--3. Число погибших пешеходов по годам
#with cte_1 (acc_number, severity, user_cat) as (select acc_number, severity, user_cat  from users_new where severity=2 and user_cat=3 group by severity, acc_number, user_cat) select count(*), year from cte_1 left join caracteristics_new on cte_1.acc_number=caracteristics_new.acc_number group by year order by year;
df=users.merge(caracteristics, how='inner', left_on='acc_number', right_on='acc_number')
df=df.loc[df['severity']==2]
df=df.loc[df['user_cat']==3].groupby('year')['acc_number'].count()
df

#--4. Количество аварий в зависимости от дорожного покрытия
#select surface_cond, count(*) as num_acc from places_new group by surface_cond order by num_acc desc;

places.groupby('surface_cond')['acc_number'].count().sort_values(ascending=False)

#--5. Количество аварий в зависимости от погоды
#select atm_cond, count(*) as num_acc from caracteristics_new group by atm_cond order by num_acc desc;

caracteristics.groupby('atm_cond')['acc_number'].count().sort_values(ascending=False)




