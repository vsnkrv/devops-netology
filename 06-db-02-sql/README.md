# Домашнее задание к занятию "6.2. SQL"

## Введение

Перед выполнением задания вы можете ознакомиться с 
[дополнительными материалами](https://github.com/netology-code/virt-homeworks/tree/master/additional/README.md).

## Задача 1

Используя docker поднимите инстанс PostgreSQL (версию 12) c 2 volume, 
в который будут складываться данные БД и бэкапы.

Приведите получившуюся команду или docker-compose манифест.

```
root@server1:~/06-db-02-sql# cat docker-compose.yml 
version: "3.9"
services:
  postgres:
    image: postgres:12.12
    container_name: pg
    environment:
      POSTGRES_DB: "postgres"
      POSTGRES_USER: "user"
      POSTGRES_PASSWORD: "password"
    volumes:
      - ~/postgresql/data:/var/lib/postgresql/data
      - ~/postgresql/data:/var/lib/postgresql/backup
    ports:
      - "5432:5432"
root@server1:~/06-db-02-sql#
```

## Задача 2

В БД из задачи 1: 
- создайте пользователя test-admin-user и БД test_db
- в БД test_db создайте таблицу orders и clients (спeцификация таблиц ниже)
- предоставьте привилегии на все операции пользователю test-admin-user на таблицы БД test_db
- создайте пользователя test-simple-user  
- предоставьте пользователю test-simple-user права на SELECT/INSERT/UPDATE/DELETE данных таблиц БД test_db

Таблица orders:
- id (serial primary key)
- наименование (string)
- цена (integer)

Таблица clients:
- id (serial primary key)
- фамилия (string)
- страна проживания (string, index)
- заказ (foreign key orders)

Приведите:
- итоговый список БД после выполнения пунктов выше,
- описание таблиц (describe)
- SQL-запрос для выдачи списка пользователей с правами над таблицами test_db
- список пользователей с правами над таблицами test_db

```
root@server1:~/06-db-02-sql# psql -h localhost -U user postgres
Password for user user: 
psql (12.12 (Ubuntu 12.12-0ubuntu0.20.04.1))
Type "help" for help.

postgres=# CREATE DATABASE test_db;
CREATE DATABASE
postgres=# CREATE USER "test-admin-user" WITH PASSWORD 'password';
CREATE ROLE
postgres=# \c test_db;
You are now connected to database "test_db" as user "user".
test_db=# CREATE TABLE orders (id INT PRIMARY KEY, title VARCHAR(255), cost INT NOT NULL);
CREATE TABLE
test_db=# CREATE TABLE clients (id SERIAL PRIMARY KEY, last_name VARCHAR(50), country VARCHAR(50), order_id INT REFERENCES orders(id) ON DELETE CASCADE);
CREATE TABLE
test_db=# GRANT CONNECT ON DATABASE test_db to "test-admin-user";
GRANT
test_db=# GRANT ALL ON ALL TABLES IN SCHEMA public to "test-admin-user";
GRANT
test_db=# CREATE USER "test-simple-user" WITH PASSWORD 'test';
CREATE ROLE
test_db=# GRANT CONNECT ON DATABASE test_db TO "test-simple-user";
GRANT
test_db=# GRANT USAGE ON SCHEMA public TO "test-simple-user";
GRANT
test_db=# GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public to "test-simple-user";
GRANT
test_db=# \l
                                 List of databases
   Name    | Owner | Encoding |  Collate   |   Ctype    |     Access privileges     
-----------+-------+----------+------------+------------+---------------------------
 postgres  | user  | UTF8     | en_US.utf8 | en_US.utf8 | 
 template0 | user  | UTF8     | en_US.utf8 | en_US.utf8 | =c/user                  +
           |       |          |            |            | user=CTc/user
 template1 | user  | UTF8     | en_US.utf8 | en_US.utf8 | =c/user                  +
           |       |          |            |            | user=CTc/user
 test_db   | user  | UTF8     | en_US.utf8 | en_US.utf8 | =Tc/user                 +
           |       |          |            |            | user=CTc/user            +
           |       |          |            |            | "test-admin-user"=c/user +
           |       |          |            |            | "test-simple-user"=c/user
(4 rows)

test_db=# \d+ orders
                                          Table "public.orders"
 Column |          Type          | Collation | Nullable | Default | Storage  | Stats target | Description 
--------+------------------------+-----------+----------+---------+----------+--------------+-------------
 id     | integer                |           | not null |         | plain    |              | 
 title  | character varying(255) |           |          |         | extended |              | 
 cost   | integer                |           | not null |         | plain    |              | 
Indexes:
    "orders_pkey" PRIMARY KEY, btree (id)
Referenced by:
    TABLE "clients" CONSTRAINT "clients_order_id_fkey" FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE
Access method: heap

test_db=# \d+ clients
                                                         Table "public.clients"
  Column   |         Type          | Collation | Nullable |               Default               | Storage  | Stats target | Description 
-----------+-----------------------+-----------+----------+-------------------------------------+----------+--------------+-------------
 id        | integer               |           | not null | nextval('clients_id_seq'::regclass) | plain    |              | 
 last_name | character varying(50) |           |          |                                     | extended |              | 
 country   | character varying(50) |           |          |                                     | extended |              | 
 order_id  | integer               |           |          |                                     | plain    |              | 
Indexes:
    "clients_pkey" PRIMARY KEY, btree (id)
Foreign-key constraints:
    "clients_order_id_fkey" FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE
Access method: heap

test_db=# SELECT * FROM information_schema.table_privileges WHERE table_catalog = 'test_db' AND grantee LIKE 'test-%';
 grantor |     grantee      | table_catalog | table_schema | table_name | privilege_type | is_grantable | with_hierarchy 
---------+------------------+---------------+--------------+------------+----------------+--------------+----------------
 user    | test-admin-user  | test_db       | public       | orders     | INSERT         | NO           | NO
 user    | test-admin-user  | test_db       | public       | orders     | SELECT         | NO           | YES
 user    | test-admin-user  | test_db       | public       | orders     | UPDATE         | NO           | NO
 user    | test-admin-user  | test_db       | public       | orders     | DELETE         | NO           | NO
 user    | test-admin-user  | test_db       | public       | orders     | TRUNCATE       | NO           | NO
 user    | test-admin-user  | test_db       | public       | orders     | REFERENCES     | NO           | NO
 user    | test-admin-user  | test_db       | public       | orders     | TRIGGER        | NO           | NO
 user    | test-admin-user  | test_db       | public       | clients    | INSERT         | NO           | NO
 user    | test-admin-user  | test_db       | public       | clients    | SELECT         | NO           | YES
 user    | test-admin-user  | test_db       | public       | clients    | UPDATE         | NO           | NO
 user    | test-admin-user  | test_db       | public       | clients    | DELETE         | NO           | NO
 user    | test-admin-user  | test_db       | public       | clients    | TRUNCATE       | NO           | NO
 user    | test-admin-user  | test_db       | public       | clients    | REFERENCES     | NO           | NO
 user    | test-admin-user  | test_db       | public       | clients    | TRIGGER        | NO           | NO
 user    | test-simple-user | test_db       | public       | orders     | INSERT         | NO           | NO
 user    | test-simple-user | test_db       | public       | orders     | SELECT         | NO           | YES
 user    | test-simple-user | test_db       | public       | orders     | UPDATE         | NO           | NO
 user    | test-simple-user | test_db       | public       | orders     | DELETE         | NO           | NO
 user    | test-simple-user | test_db       | public       | clients    | INSERT         | NO           | NO
 user    | test-simple-user | test_db       | public       | clients    | SELECT         | NO           | YES
 user    | test-simple-user | test_db       | public       | clients    | UPDATE         | NO           | NO
 user    | test-simple-user | test_db       | public       | clients    | DELETE         | NO           | NO
(22 rows)

test_db=#
```

## Задача 3

Используя SQL синтаксис - наполните таблицы следующими тестовыми данными:

Таблица orders

|Наименование|цена|
|------------|----|
|Шоколад| 10 |
|Принтер| 3000 |
|Книга| 500 |
|Монитор| 7000|
|Гитара| 4000|

Таблица clients

|ФИО|Страна проживания|
|------------|----|
|Иванов Иван Иванович| USA |
|Петров Петр Петрович| Canada |
|Иоганн Себастьян Бах| Japan |
|Ронни Джеймс Дио| Russia|
|Ritchie Blackmore| Russia|

Используя SQL синтаксис:
- вычислите количество записей для каждой таблицы 
- приведите в ответе:
- запросы 
- результаты их выполнения.

```
test_db=# INSERT INTO orders VALUES (1, 'Шоколад', 10), (2, 'Принтер', 3000), (3, 'Книга', 500), (4, 'Монитор', 7000), (5, 'Гитара', 4000);
INSERT 0 5
test_db=# SELECT * FROM orders;
 id |  title  | cost 
----+---------+------
  1 | Шоколад |   10
  2 | Принтер | 3000
  3 | Книга   |  500
  4 | Монитор | 7000
  5 | Гитара  | 4000
(5 rows)

test_db=# INSERT INTO clients VALUES (1, 'Иванов Иван Иванович', 'USA'), (2, 'Петров Петр Петрович', 'Canada'), (3, 'Иоганн Себастьян Бах', 'Japan'), (4, 'Ронни Джеймс Дио', 'Russia'), (5, 'Ritchie Blackmore', 'Russia');
INSERT 0 5
test_db=# SELECT * FROM clients;
 id |      last_name       | country | order_id 
----+----------------------+---------+----------
  1 | Иванов Иван Иванович | USA     |         
  2 | Петров Петр Петрович | Canada  |         
  3 | Иоганн Себастьян Бах | Japan   |         
  4 | Ронни Джеймс Дио     | Russia  |         
  5 | Ritchie Blackmore    | Russia  |         
(5 rows)

test_db=#
```

## Задача 4

Часть пользователей из таблицы clients решили оформить заказы из таблицы orders.

Используя foreign keys свяжите записи из таблиц, согласно таблице:

|ФИО|Заказ|
|------------|----|
|Иванов Иван Иванович| Книга |
|Петров Петр Петрович| Монитор |
|Иоганн Себастьян Бах| Гитара |

Приведите SQL-запросы для выполнения данных операций.

Приведите SQL-запрос для выдачи всех пользователей, которые совершили заказ, а также вывод данного запроса.
 
Подсказк - используйте директиву `UPDATE`.

```
test_db=# UPDATE clients SET order_id = 3 WHERE last_name = 'Иванов Иван Иванович';
UPDATE 1
test_db=# UPDATE clients SET order_id = 4 WHERE last_name = 'Петров Петр Петрович';
UPDATE 1
test_db=# UPDATE clients SET order_id = 5 WHERE last_name = 'Иоганн Себастьян Бах';
UPDATE 1
test_db=# SELECT c.id, c.last_name, c.country, o.title FROM clients AS c INNER JOIN orders AS o ON o.id = c.order_id;
 id |      last_name       | country |  title  
----+----------------------+---------+---------
  1 | Иванов Иван Иванович | USA     | Книга
  2 | Петров Петр Петрович | Canada  | Монитор
  3 | Иоганн Себастьян Бах | Japan   | Гитара
(3 rows)

test_db=#
```

## Задача 5

Получите полную информацию по выполнению запроса выдачи всех пользователей из задачи 4 
(используя директиву EXPLAIN).

Приведите получившийся результат и объясните что значат полученные значения.

```
test_db=# EXPLAIN SELECT c.id, c.last_name, c.country, o.title FROM clients AS c INNER JOIN orders AS o ON o.id = c.order_id;
                               QUERY PLAN                                
-------------------------------------------------------------------------
 Hash Join  (cost=13.15..26.96 rows=300 width=756)
   Hash Cond: (c.order_id = o.id)
   ->  Seq Scan on clients c  (cost=0.00..13.00 rows=300 width=244)
   ->  Hash  (cost=11.40..11.40 rows=140 width=520)
         ->  Seq Scan on orders o  (cost=0.00..11.40 rows=140 width=520)
(5 rows)

test_db=#
```

EXPLAIN - вывод плана построения запроса.

- время которое пройдет перед выводом данных, приблизительная стоимость запуска;
- расчетное время для вывода всех данных, приблизительная общая стоимость;
- ожидаемое число строк;
- ожидамый средний размер строк в байтах.

## Задача 6

Создайте бэкап БД test_db и поместите его в volume, предназначенный для бэкапов (см. Задачу 1).

Остановите контейнер с PostgreSQL (но не удаляйте volumes).

Поднимите новый пустой контейнер с PostgreSQL.

Восстановите БД test_db в новом контейнере.

Приведите список операций, который вы применяли для бэкапа данных и восстановления. 

```
root@server1:~/06-db-02-sql# docker run --rm -d -e POSTGRES_USER=user -e POSTGRES_PASSWORD=password -e POSTGRES_DB=postgres -v ~/postgresql/backup:/var/lib/postgresql/backup --name pg_r postgres:12.12
00567bbe9e34a31b0daf28112df0374091778b3bb8f84b220315d18e6d0597ce
root@server1:~/06-db-02-sql# docker container exec -it pg_r /bin/bash
root@00567bbe9e34:/# psql -U user postgres
psql (12.12 (Debian 12.12-1.pgdg110+1))
Type "help" for help.

postgres=# CREATE DATABASE test_db;
CREATE DATABASE
postgres=# CREATE USER "test-admin-user" WITH PASSWORD 'password';
CREATE ROLE
postgres=# CREATE USER "test-simple-user" WITH PASSWORD 'test';
CREATE ROLE
postgres=# exit
root@00567bbe9e34:/# psql -U user test_db < /var/lib/postgresql/backup/test_db.sql 
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
CREATE TABLE
ALTER TABLE
ALTER TABLE
COPY 5
COPY 5
 setval 
--------
      1
(1 row)

ALTER TABLE
ALTER TABLE
ALTER TABLE
GRANT
GRANT
GRANT
GRANT
GRANT
root@00567bbe9e34:/#
```

---

### Как cдавать задание

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---
