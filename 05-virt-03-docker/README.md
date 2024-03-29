
# Домашнее задание к занятию "5.3. Введение. Экосистема. Архитектура. Жизненный цикл Docker контейнера"

## Как сдавать задания

Обязательными к выполнению являются задачи без указания звездочки. Их выполнение необходимо для получения зачета и диплома о профессиональной переподготовке.

Задачи со звездочкой (*) являются дополнительными задачами и/или задачами повышенной сложности. Они не являются обязательными к выполнению, но помогут вам глубже понять тему.

Домашнее задание выполните в файле readme.md в github репозитории. В личном кабинете отправьте на проверку ссылку на .md-файл в вашем репозитории.

Любые вопросы по решению задач задавайте в чате Slack.

---

## Задача 1

Сценарий выполения задачи:

- создайте свой репозиторий на https://hub.docker.com;
- выберете любой образ, который содержит веб-сервер Nginx;
- создайте свой fork образа;
- реализуйте функциональность:
запуск веб-сервера в фоне с индекс-страницей, содержащей HTML-код ниже:

```
<html>
<head>
Hey, Netology
</head>
<body>
<h1>I’m DevOps Engineer!</h1>
</body>
</html>
```
Опубликуйте созданный форк в своем репозитории и предоставьте ответ в виде ссылки на https://hub.docker.com/username_repo.

```
vagrant@server1:~$ docker run -p 80:80 -d nginx
Unable to find image 'nginx:latest' locally
latest: Pulling from library/nginx
1efc276f4ff9: Pull complete 
baf2da91597d: Pull complete 
05396a986fd3: Pull complete 
6a17c8e7063d: Pull complete 
27e0d286aeab: Pull complete 
b1349eea8fc5: Pull complete 
Digest: sha256:790711e34858c9b0741edffef6ed3d8199d8faa33f2870dea5db70f16384df79
Status: Downloaded newer image for nginx:latest
6231d367480958e5ab3d9529eb9d5a02409d022af6c91637e1d5633a26f66a96
vagrant@server1:~$ cat > index.html
<html>
<head>
Hey, Netology
</head>
<body>
<h1>I’m DevOps Engineer!</h1>
</body>
</html>
^C
vagrant@server1:~$ docker ps
CONTAINER ID   IMAGE     COMMAND                  CREATED              STATUS              PORTS                               NAMES
6231d3674809   nginx     "/docker-entrypoint.…"   About a minute ago   Up About a minute   0.0.0.0:80->80/tcp, :::80->80/tcp   affectionate_maxwell
vagrant@server1:~$ docker cp index.html 6231d3674809:/usr/share/nginx/html/
vagrant@server1:~$ docker restart 6231d3674809
6231d3674809
vagrant@server1:~$ curl localhost:80
<html>
<head>
Hey, Netology
</head>
<body>
<h1>I’m DevOps Engineer!</h1>
</body>
</html>
vagrant@server1:~$ docker image list
REPOSITORY   TAG       IMAGE ID       CREATED       SIZE
nginx        latest    b692a91e4e15   2 weeks ago   142MB
vagrant@server1:~$ docker tag nginx:latest vsnkrv/nginx:05-virt-03-docker
vagrant@server1:~$ docker login -u vsnkrv
Password: 
WARNING! Your password will be stored unencrypted in /home/vagrant/.docker/config.json.
Configure a credential helper to remove this warning. See
https://docs.docker.com/engine/reference/commandline/login/#credentials-store

Login Succeeded
vagrant@server1:~$ docker push vsnkrv/nginx:05-virt-03-docker
The push refers to repository [docker.io/vsnkrv/nginx]
b539cf60d7bb: Mounted from library/nginx 
bdc7a32279cc: Mounted from library/nginx 
f91d0987b144: Mounted from library/nginx 
3a89c8160a43: Mounted from library/nginx 
e3257a399753: Mounted from library/nginx 
92a4e8a3140f: Mounted from library/nginx 
05-virt-03-docker: digest: sha256:f26fbadb0acab4a21ecb4e337a326907e61fbec36c9a9b52e725669d99ed1261 size: 1570
vagrant@server1:~$
```

[https://hub.docker.com/repository/docker/vsnkrv/nginx/](https://hub.docker.com/repository/docker/vsnkrv/nginx/)

*FIX1*

```
vagrant@server1:~$ cat ./index.html 
<html>
<head>
Hey, Netology
</head>
<body>
<h1>I’m DevOps Engineer!</h1>
</body>
</html>
vagrant@server1:~$ cat ./Dockerfile 
FROM nginx
COPY index.html /usr/share/nginx/html/
EXPOSE 80
vagrant@server1:~$ docker build -t vsnkrv/nginx:05-virt-03-docker .
Sending build context to Docker daemon  40.45kB
Step 1/3 : FROM nginx
latest: Pulling from library/nginx
7a6db449b51b: Already exists 
ca1981974b58: Already exists 
d4019c921e20: Already exists 
7cb804d746d4: Already exists 
e7a561826262: Already exists 
7247f6e5c182: Already exists 
Digest: sha256:f15eab733ef99f91d1ad3ab6192ded46a15e4e58cf8fb9ddbe6c6618450e683c
Status: Downloaded newer image for nginx:latest
 ---> 2b7d6430f78d
Step 2/3 : COPY index.html /usr/share/nginx/html/
 ---> 754de8516aab
Step 3/3 : EXPOSE 80
 ---> Running in 9b4ebac1ec43
Removing intermediate container 9b4ebac1ec43
 ---> f1fa1e704b7c
Successfully built f1fa1e704b7c
Successfully tagged vsnkrv/nginx:05-virt-03-docker
vagrant@server1:~$ docker image list
REPOSITORY     TAG                 IMAGE ID       CREATED          SIZE
vsnkrv/nginx   05-virt-03-docker   f1fa1e704b7c   14 seconds ago   142MB
nginx          latest              2b7d6430f78d   7 hours ago      142MB
debian         latest              07d9246c53a6   3 weeks ago      124MB
centos         latest              5d0da3dc9764   11 months ago    231MB
vagrant@server1:~$ docker run -P -d vsnkrv/nginx:05-virt-03-docker
56516372f0520a38d7cf3cedbfefc30e1e713ac554b25f5af3c057c09f663d5c
vagrant@server1:~$ docker ps
CONTAINER ID   IMAGE                            COMMAND                  CREATED         STATUS         PORTS                                     NAMES
56516372f052   vsnkrv/nginx:05-virt-03-docker   "/docker-entrypoint.…"   8 seconds ago   Up 7 seconds   0.0.0.0:49155->80/tcp, :::49155->80/tcp   funny_jemison
vagrant@server1:~$ curl localhost:49155
<html>
<head>
Hey, Netology
</head>
<body>
<h1>I’m DevOps Engineer!</h1>
</body>
</html>
vagrant@server1:~$ docker stop 56516372f052
56516372f052
vagrant@server1:~$ docker login
Authenticating with existing credentials...
WARNING! Your password will be stored unencrypted in /home/vagrant/.docker/config.json.
Configure a credential helper to remove this warning. See
https://docs.docker.com/engine/reference/commandline/login/#credentials-store

Login Succeeded
vagrant@server1:~$ docker push vsnkrv/nginx:05-virt-03-docker
The push refers to repository [docker.io/vsnkrv/nginx]
039f7dea289c: Pushed 
73993eeb8aa2: Mounted from library/nginx 
2c31eef17db8: Mounted from library/nginx 
7b9055fc8058: Mounted from library/nginx 
04ab349b7b3b: Mounted from library/nginx 
226117031573: Mounted from library/nginx 
6485bed63627: Mounted from library/nginx 
05-virt-03-docker: digest: sha256:74cb8556ddf335dd9338ac3327c5b695172f6b53728038d05ae1379291848c31 size: 1777
vagrant@server1:~$
```

[https://hub.docker.com/repository/docker/vsnkrv/nginx/](https://hub.docker.com/repository/docker/vsnkrv/nginx/)


## Задача 2

Посмотрите на сценарий ниже и ответьте на вопрос:
"Подходит ли в этом сценарии использование Docker контейнеров или лучше подойдет виртуальная машина, физическая машина? Может быть возможны разные варианты?"

Детально опишите и обоснуйте свой выбор.

--

Сценарий:

- Высоконагруженное монолитное java веб-приложение;

ВМ / Физический сервер, так как высоконагруженное.

- Nodejs веб-приложение;

Docker, так как позволяет проводить быструю разработку и тестирование

- Мобильное приложение c версиями для Android и iOS;

Docker, так как позволяет проводить быструю разработку и тестирование

- Шина данных на базе Apache Kafka;

Docker

- Elasticsearch кластер для реализации логирования продуктивного веб-приложения - три ноды elasticsearch, два logstash и две ноды kibana;

Docker

- Мониторинг-стек на базе Prometheus и Grafana;

Docker

- MongoDB, как основное хранилище данных для java-приложения;

Docker, при условии хранеиня данных вне контейнера

- Gitlab сервер для реализации CI/CD процессов и приватный (закрытый) Docker Registry.

ВМ / Физический сервер, исходя из требований

## Задача 3

- Запустите первый контейнер из образа ***centos*** c любым тэгом в фоновом режиме, подключив папку ```/data``` из текущей рабочей директории на хостовой машине в ```/data``` контейнера;
- Запустите второй контейнер из образа ***debian*** в фоновом режиме, подключив папку ```/data``` из текущей рабочей директории на хостовой машине в ```/data``` контейнера;
- Подключитесь к первому контейнеру с помощью ```docker exec``` и создайте текстовый файл любого содержания в ```/data```;
- Добавьте еще один файл в папку ```/data``` на хостовой машине;
- Подключитесь во второй контейнер и отобразите листинг и содержание файлов в ```/data``` контейнера.

```bash
vagrant@server1:~$ docker run -dti -v /data:/data centos
0df86d2fc5d68bfac555f6db2ac387293210820ca64d5435de70edaf2c423619
vagrant@server1:~$ docker run -dti -v /data:/data debian
19964c9d399166e5e0a02b37634cbc37b52f0bf4bb7cd0252b5c31b7d05c2f55
vagrant@server1:~$ docker ps
CONTAINER ID   IMAGE     COMMAND       CREATED          STATUS          PORTS     NAMES
19964c9d3991   debian    "bash"        5 seconds ago    Up 4 seconds              practical_satoshi
0df86d2fc5d6   centos    "/bin/bash"   14 seconds ago   Up 13 seconds             optimistic_thompson
vagrant@server1:~$ docker exec -it 0df86d2fc5d6 touch /data/file1
vagrant@server1:~$ touch /data/file2
vagrant@server1:~$ sudo touch /data/file2
vagrant@server1:~$ docker exec -it 19964c9d3991 ls -l /data
total 0
-rw-r--r-- 1 root root 0 Aug 22 10:05 file1
-rw-r--r-- 1 root root 0 Aug 22 10:06 file2
vagrant@server1:~$
```

## Задача 4 (*)

Воспроизвести практическую часть лекции самостоятельно.

Соберите Docker образ с Ansible, загрузите на Docker Hub и пришлите ссылку вместе с остальными ответами к задачам.


---

### Как cдавать задание

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---
