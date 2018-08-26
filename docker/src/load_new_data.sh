#/bin/sh


psql --host $APP_POSTGRES_HOST  -U postgres -c \
    "DROP TABLE IF EXISTS users_new"
psql --host $APP_POSTGRES_HOST  -U postgres -c \
    "DROP TABLE IF EXISTS vehicles_new"
psql --host $APP_POSTGRES_HOST  -U postgres -c \
    "DROP TABLE IF EXISTS places_new"
psql --host $APP_POSTGRES_HOST  -U postgres -c \
    "DROP TABLE IF EXISTS caracteristics_new "





echo "Загружаем users_new.csv..."
psql --host $APP_POSTGRES_HOST -U postgres -c '
  CREATE TABLE users_new (
    id int, acc_number bigint, user_cat int, severity int, sex int, secu float, year_birth float
  );'
psql --host $APP_POSTGRES_HOST  -U postgres -c "\\copy users_new FROM '/data/users_new.csv' DELIMITER ',' CSV HEADER";



echo "Загружаем vehicles_new.csv..."
psql --host $APP_POSTGRES_HOST -U postgres -c ' CREATE TABLE IF NOT EXISTS vehicles_new (id int, acc_number bigint, cat float);'
psql --host $APP_POSTGRES_HOST  -U postgres -c "\\copy vehicles_new FROM '/data/vehicles_new.csv' DELIMITER ',' CSV HEADER";


echo "Загружаем caracteristics_new.csv..."
psql --host $APP_POSTGRES_HOST -U postgres -c ' CREATE TABLE IF NOT EXISTS caracteristics_new (id int, acc_number bigint, year int, month int, day int, hour int, light_cond int, atm_cond float, department int);'
psql --host $APP_POSTGRES_HOST  -U postgres -c "\\copy caracteristics_new FROM '/data/car_new.csv' delimiter ',' CSV HEADER";


echo "Загружаем places_new.csv..."
psql --host $APP_POSTGRES_HOST -U postgres -c ' CREATE TABLE IF NOT EXISTS places_new (id int, acc_number bigint, road_cat int, traffic_type int, number_lines int, surface_cond int, infra int, situation int);'
psql --host $APP_POSTGRES_HOST  -U postgres -c "\\copy places_new  FROM '/data/places_new.csv' DELIMITER ',' CSV HEADER";





