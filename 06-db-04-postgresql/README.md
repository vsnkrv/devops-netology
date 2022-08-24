# Домашнее задание к занятию "6.4. PostgreSQL"

## Задача 1

Используя docker поднимите инстанс PostgreSQL (версию 13). Данные БД сохраните в volume.

Подключитесь к БД PostgreSQL используя `psql`.

Воспользуйтесь командой `\?` для вывода подсказки по имеющимся в `psql` управляющим командам.

**Найдите и приведите** управляющие команды для:
- вывода списка БД - \l
- подключения к БД - \c
- вывода списка таблиц - \d
- вывода описания содержимого таблиц - \d <имя_таблицы>
- выхода из psql - \q

## Задача 2

Используя `psql` создайте БД `test_database`.

Изучите [бэкап БД](https://github.com/netology-code/virt-homeworks/tree/master/06-db-04-postgresql/test_data).

Восстановите бэкап БД в `test_database`.

Перейдите в управляющую консоль `psql` внутри контейнера.

Подключитесь к восстановленной БД и проведите операцию ANALYZE для сбора статистики по таблице.

Используя таблицу [pg_stats](https://postgrespro.ru/docs/postgresql/12/view-pg-stats), найдите столбец таблицы `orders` 
с наибольшим средним значением размера элементов в байтах.

**Приведите в ответе** команду, которую вы использовали для вычисления и полученный результат.

```
root@server1:~# docker container exec -it pg /bin/bash
root@fe1faa3f3642:/# psql -h localhost -U postgres postgres
psql (13.8 (Debian 13.8-1.pgdg110+1))
Type "help" for help.

postgres=# CREATE DATABASE test_database;
CREATE DATABASE
postgres=# 
\q
root@fe1faa3f3642:/# psql -h localhost -U postgres test_database < /var/lib/postgresql/backup/test_dump.sql 
SET
SET
SET
SET
SET
 set_config 
------------
 
(1 row)

SET
SET
SET
SET
SET
SET
CREATE TABLE
ALTER TABLE
CREATE SEQUENCE
ALTER TABLE
ALTER SEQUENCE
ALTER TABLE
COPY 8
 setval 
--------
      8
(1 row)

ALTER TABLE
root@fe1faa3f3642:/# psql -h localhost -U postgres postgres
psql (13.8 (Debian 13.8-1.pgdg110+1))
Type "help" for help.

postgres=# 
\q
root@fe1faa3f3642:/# psql -h localhost -U postgres test_database
psql (13.8 (Debian 13.8-1.pgdg110+1))
Type "help" for help.

test_database=# \dt
         List of relations
 Schema |  Name  | Type  |  Owner   
--------+--------+-------+----------
 public | orders | table | postgres
(1 row)

test_database=# ANALYZE VERBOSE public.orders;
INFO:  analyzing "public.orders"
INFO:  "orders": scanned 1 of 1 pages, containing 8 live rows and 0 dead rows; 8 rows in sample, 8 estimated total rows
ANALYZE
test_database=# SELECT attname, avg_width FROM pg_stats WHERE tablename = 'orders' ORDER BY avg_width DESC LIMIT 1;
 attname | avg_width 
---------+-----------
 title   |        16
(1 row)

test_database=#
```

## Задача 3

Архитектор и администратор БД выяснили, что ваша таблица orders разрослась до невиданных размеров и
поиск по ней занимает долгое время. Вам, как успешному выпускнику курсов DevOps в нетологии предложили
провести разбиение таблицы на 2 (шардировать на orders_1 - price>499 и orders_2 - price<=499).

Предложите SQL-транзакцию для проведения данной операции.

```
test_database=# ALTER TABLE orders RENAME to orders_old;
ALTER TABLE
test_database=# CREATE TABLE orders (id integer, title varchar(80), price integer) PARTITION BY RANGE (price);
CREATE TABLE
test_database=# CREATE TABLE orders_1 partition of orders for values FROM (MINVALUE) to (499);
CREATE TABLE
test_database=# CREATE TABLE orders_2 partition of orders for values FROM (499) to (MAXVALUE);
CREATE TABLE
test_database=# INSERT INTO orders (id, title, price) SELECT * FROM orders_old;
INSERT 0 8
test_database=# DROP TABLE orders_old;
DROP TABLE
test_database=# 
```

Можно ли было изначально исключить "ручное" разбиение при проектировании таблицы orders?

*Партиционирование таблицы, можно делать при проектировании БД*


## Задача 4

Используя утилиту `pg_dump` создайте бекап БД `test_database`.

*pg_dump -h localhost -U postgres test_database > /var/lib/postgresql/backup/test_dump_new.sql*

Как бы вы доработали бэкап-файл, чтобы добавить уникальность значения столбца `title` для таблиц `test_database`?

---

### Как cдавать задание

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---
