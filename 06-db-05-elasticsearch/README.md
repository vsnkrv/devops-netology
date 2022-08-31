# Домашнее задание к занятию "6.5. Elasticsearch"

## Задача 1

В этом задании вы потренируетесь в:
- установке elasticsearch
- первоначальном конфигурировании elastcisearch
- запуске elasticsearch в docker

Используя докер образ [centos:7](https://hub.docker.com/_/centos) как базовый и 
[документацию по установке и запуску Elastcisearch](https://www.elastic.co/guide/en/elasticsearch/reference/current/targz.html):

- составьте Dockerfile-манифест для elasticsearch
- соберите docker-образ и сделайте `push` в ваш docker.io репозиторий
- запустите контейнер из получившегося образа и выполните запрос пути `/` c хост-машины

Требования к `elasticsearch.yml`:
- данные `path` должны сохраняться в `/var/lib`
- имя ноды должно быть `netology_test`

В ответе приведите:
- текст Dockerfile манифеста

```
user@acer-r:~/devops-netology/06-db-05-elasticsearch$ cat Dockerfile 
FROM centos:7
   
ENV ES_USER="elastic"
ENV ES_HOME="/opt/elasticsearch/elasticsearch-8.4.0"
ENV ES_DATA="/var/lib/elasticsearch"
ENV ES_LOG="/var/log/elasticsearch"
ENV ES_BACKUP="/opt/backups"

WORKDIR /opt/elasticsearch

RUN yum install wget perl-Digest-SHA -y && \
    wget -q https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-8.4.0-linux-x86_64.tar.gz && \
    wget -q https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-8.4.0-linux-x86_64.tar.gz.sha512 && \
    shasum -a 512 -c elasticsearch-8.4.0-linux-x86_64.tar.gz.sha512 && \
    tar -xzf elasticsearch-8.4.0-linux-x86_64.tar.gz && \
    rm -f elasticsearch-8.4.0-linux-x86_64.tar.gz && \
    cd elasticsearch-8.4.0/ && \
    yum clean all -y
  
COPY elasticsearch.yml ${ES_HOME}/config/elasticsearch.yml

RUN useradd "${ES_USER}" && \
    mkdir -p "${ES_DATA}" "${ES_LOG}" "${ES_BACKUP}" && \
    chown -R ${ES_USER}: /opt/elasticsearch "${ES_DATA}" "${ES_LOG}" "${ES_BACKUP}"

USER ${ES_USER}

WORKDIR "${ES_HOME}"
 
EXPOSE 9200
EXPOSE 9300    
    
CMD ["./bin/elasticsearch"]
user@acer-r:~/devops-netology/06-db-05-elasticsearch$
```

- ссылку на образ в репозитории dockerhub

build не проходит без ошибок, так как elasticsearch не скачивается, нет смысла push

- ответ `elasticsearch` на запрос пути `/` в json виде

```
vagrant@server1:~$ curl --insecure -u elastic https://localhost:9200/
Enter host password for user 'elastic':
{
  "name" : "dfe501aa632d",
  "cluster_name" : "docker-cluster",
  "cluster_uuid" : "i9LCqGThTgyobfhVmBU0WQ",
  "version" : {
    "number" : "8.4.0",
    "build_flavor" : "default",
    "build_type" : "docker",
    "build_hash" : "f56126089ca4db89b631901ad7cce0a8e10e2fe5",
    "build_date" : "2022-08-19T19:23:42.954591481Z",
    "build_snapshot" : false,
    "lucene_version" : "9.3.0",
    "minimum_wire_compatibility_version" : "7.17.0",
    "minimum_index_compatibility_version" : "7.0.0"
  },
  "tagline" : "You Know, for Search"
}
vagrant@server1:~$
```

Подсказки:
- возможно вам понадобится установка пакета perl-Digest-SHA для корректной работы пакета shasum
- при сетевых проблемах внимательно изучите кластерные и сетевые настройки в elasticsearch.yml
- при некоторых проблемах вам поможет docker директива ulimit
- elasticsearch в логах обычно описывает проблему и пути ее решения

Далее мы будем работать с данным экземпляром elasticsearch.

## Задача 2

В этом задании вы научитесь:
- создавать и удалять индексы
- изучать состояние кластера
- обосновывать причину деградации доступности данных

Ознакомтесь с [документацией](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-create-index.html) 
и добавьте в `elasticsearch` 3 индекса, в соответствии со таблицей:

| Имя | Количество реплик | Количество шард |
|-----|-------------------|-----------------|
| ind-1| 0 | 1 |
| ind-2 | 1 | 2 |
| ind-3 | 2 | 4 |

```
vagrant@server1:~$ curl --insecure -u elastic -XPUT https://localhost:9200/ind-1 -H 'Content-Type: application/json' -d'{ "settings": { "number_of_shards": 1,  "number_of_replicas": 0 }}'
Enter host password for user 'elastic':
{"acknowledged":true,"shards_acknowledged":true,"index":"ind-1"}vagrant@server1:~$ 
vagrant@server1:~$ curl --insecure -u elastic -XPUT https://localhost:9200/ind-2 -H 'Content-Type: application/json' -d'{ "settings": { "number_of_shards": 2,  "number_of_replicas": 1 }}'
Enter host password for user 'elastic':
{"acknowledged":true,"shards_acknowledged":true,"index":"ind-2"}vagrant@server1:~$ 
vagrant@server1:~$ curl --insecure -u elastic -XPUT https://localhost:9200/ind-3 -H 'Content-Type: application/json' -d'{ "settings": { "number_of_shards": 4,  "number_of_replicas": 2 }}'
Enter host password for user 'elastic':
{"acknowledged":true,"shards_acknowledged":true,"index":"ind-3"}vagrant@server1:~$ 
vagrant@server1:~$
```

Получите список индексов и их статусов, используя API и **приведите в ответе** на задание.

```
vagrant@server1:~$ curl --insecure -u elastic -XGET "https://localhost:9200/_cat/indices"
Enter host password for user 'elastic':
green  open ind-1 ZxKCLbwtSaK9EJZ50JfZyg 1 0 0 0 225b 225b
yellow open ind-3 JiZWMCXvRSy5llwR7ygmrg 4 2 0 0 900b 900b
yellow open ind-2 1DnnQnj7RWK8rZ00N45dGA 2 1 0 0 450b 450b
vagrant@server1:~$
```

Получите состояние кластера `elasticsearch`, используя API.

```
vagrant@server1:~$ curl --insecure -u elastic -XGET "https://localhost:9200/_cluster/health/?pretty=true"
Enter host password for user 'elastic':
{
  "cluster_name" : "docker-cluster",
  "status" : "yellow",
  "timed_out" : false,
  "number_of_nodes" : 1,
  "number_of_data_nodes" : 1,
  "active_primary_shards" : 9,
  "active_shards" : 9,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 10,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 47.368421052631575
}
vagrant@server1:~$
```

Как вы думаете, почему часть индексов и кластер находится в состоянии yellow?

Elasticsearch запущен в одном экземпляре

Удалите все индексы.

```
vagrant@server1:~$ curl --insecure -u elastic -XDELETE 'https://localhost:9200/ind-1'
Enter host password for user 'elastic':
{"acknowledged":true}vagrant@server1:~$ 
vagrant@server1:~$ curl --insecure -u elastic -XDELETE 'https://localhost:9200/ind-2'
Enter host password for user 'elastic':
{"acknowledged":tru
vagrant@server1:~$ curl --insecure -u elastic -XDELETE 'https://localhost:9200/ind-3'
Enter host password for user 'elastic':
{"acknowledged":true}vagrant@server1:~$
```

**Важно**

При проектировании кластера elasticsearch нужно корректно рассчитывать количество реплик и шард,
иначе возможна потеря данных индексов, вплоть до полной, при деградации системы.

## Задача 3

В данном задании вы научитесь:
- создавать бэкапы данных
- восстанавливать индексы из бэкапов

Создайте директорию `{путь до корневой директории с elasticsearch в образе}/snapshots`.

Используя API [зарегистрируйте](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-register-repository.html#snapshots-register-repository) 
данную директорию как `snapshot repository` c именем `netology_backup`.

**Приведите в ответе** запрос API и результат вызова API для создания репозитория.

```
vagrant@server1:~$ curl --insecure -u elastic -XPUT "https://localhost:9200/_snapshot/netology_backup?pretty" -H 'Content-Type: application/json' -d' { "type": "fs",   "settings": { "location": "/usr/share/elasticsearch/snapshots" } }'
Enter host password for user 'elastic':
{
  "acknowledged" : true
}
vagrant@server1:~$ curl --insecure -u elastic -XGET "https://localhost:9200/_snapshot/netology_backup?pretty"
Enter host password for user 'elastic':
{
  "netology_backup" : {
    "type" : "fs",
    "settings" : {
      "location" : "/usr/share/elasticsearch/snapshots"
    }
  }
}
```

Создайте индекс `test` с 0 реплик и 1 шардом и **приведите в ответе** список индексов.

```
vagrant@server1:~$ curl --insecure -u elastic -XPUT "https://localhost:9200/test?pretty" -H 'Content-Type: application/json' -d'{ "settings": { "index": { "number_of_shards": 1, "number_of_replicas": 0 } } }'
Enter host password for user 'elastic':
{
  "acknowledged" : true,
  "shards_acknowledged" : true,
  "index" : "test"
}
```

[Создайте `snapshot`](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-take-snapshot.html) 
состояния кластера `elasticsearch`.

**Приведите в ответе** список файлов в директории со `snapshot`ами.

```
vagrant@server1:~$ curl --insecure -u elastic -XPUT "https://localhost:9200/_snapshot/netology_backup/netology_snapshot_1?wait_for_completion=true&pretty"
Enter host password for user 'elastic':
{
  "snapshot" : {
    "snapshot" : "netology_snapshot_1",
    "uuid" : "puxDxQyeS46GMdvX_dZRoA",
    "repository" : "netology_backup",
    "version_id" : 8040099,
    "version" : "8.4.0",
    "indices" : [
      ".security-7",
      "test",
      ".geoip_databases"
    ],
    "data_streams" : [ ],
    "include_global_state" : true,
    "state" : "SUCCESS",
    "start_time" : "2022-08-31T05:07:43.866Z",
    "start_time_in_millis" : 1661922463866,
    "end_time" : "2022-08-31T05:07:45.072Z",
    "end_time_in_millis" : 1661922465072,
    "duration_in_millis" : 1206,
    "failures" : [ ],
    "shards" : {
      "total" : 3,
      "failed" : 0,
      "successful" : 3
    },
    "feature_states" : [
      {
        "feature_name" : "geoip",
        "indices" : [
          ".geoip_databases"
        ]
      },
      {
        "feature_name" : "security",
        "indices" : [
          ".security-7"
        ]
      }
    ]
  }
}
```

```
root@5b9b3186e823:/usr/share/elasticsearch# ls -l snapshots/
total 36
-rw-rw-r-- 1 elasticsearch root  1104 Aug 31 05:07 index-0
-rw-rw-r-- 1 elasticsearch root     8 Aug 31 05:07 index.latest
drwxrwxr-x 5 elasticsearch root  4096 Aug 31 05:07 indices
-rw-rw-r-- 1 elasticsearch root 18496 Aug 31 05:07 meta-puxDxQyeS46GMdvX_dZRoA.dat
-rw-rw-r-- 1 elasticsearch root   388 Aug 31 05:07 snap-puxDxQyeS46GMdvX_dZRoA.dat
root@5b9b3186e823:/usr/share/elasticsearch#
```

Удалите индекс `test` и создайте индекс `test-2`. **Приведите в ответе** список индексов.

```
vagrant@server1:~$ curl --insecure -u elastic -XDELETE "https://localhost:9200/test?pretty"
Enter host password for user 'elastic':
{
  "acknowledged" : true
}
vagrant@server1:~$ curl --insecure -u elastic -XPUT "https://localhost:9200/test-2?pretty" -H 'Content-Type: application/json' -d'{ "settings": { "index": { "number_of_shards": 1, "number_of_replicas": 0 } } }'
Enter host password for user 'elastic':
{
  "acknowledged" : true,
  "shards_acknowledged" : true,
  "index" : "test-2"
}
```

[Восстановите](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-restore-snapshot.html) состояние
кластера `elasticsearch` из `snapshot`, созданного ранее. 

**Приведите в ответе** запрос к API восстановления и итоговый список индексов.

```
vagrant@server1:~$ curl --insecure -u elastic -XPOST "https://localhost:9200/_snapshot/netology_backup/netology_snapshot_1/_restore?pretty"
Enter host password for user 'elastic':
{
  "accepted" : true
}
```

Подсказки:
- возможно вам понадобится доработать `elasticsearch.yml` в части директивы `path.repo` и перезапустить `elasticsearch`

---

### Как cдавать задание

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---
