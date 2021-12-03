# Домашнее задание к занятию "3.4. Операционные системы, лекция 2"

1. На лекции мы познакомились с [node_exporter](https://github.com/prometheus/node_exporter/releases). В демонстрации его исполняемый файл запускался в background. Этого достаточно для демо, но не для настоящей production-системы, где процессы должны находиться под внешним управлением. Используя знания из лекции по systemd, создайте самостоятельно простой [unit-файл](https://www.freedesktop.org/software/systemd/man/systemd.service.html) для node_exporter:

    * поместите его в автозагрузку,
    * предусмотрите возможность добавления опций к запускаемому процессу через внешний файл (посмотрите, например, на `systemctl cat cron`),
    * удостоверьтесь, что с помощью systemctl процесс корректно стартует, завершается, а после перезагрузки автоматически поднимается.

```bash
vagrant@vagrant:~$ cat /etc/systemd/system/node_exporter.service 
[Unit]
Description=Node Exporter
Wants=network-online.target
After=network-online.target

[Service]
User=node_exporter
Group=node_exporter
ExecStart=/usr/local/bin/node_exporter

[Install]
WantedBy=multi-user.target

vagrant@vagrant:~$ sudo systemctl daemon-reload
vagrant@vagrant:~$ systemctl enable node_exporter
Created symlink /etc/systemd/system/multi-user.target.wants/node_exporter.service → /etc/systemd/system/node_exporter.service.
vagrant@vagrant:~$ sudo systemctl start node_exporter
vagrant@vagrant:~$ sudo systemctl status node_exporter
● node_exporter.service - Node Exporter
     Loaded: loaded (/etc/systemd/system/node_exporter.service; enabled; vendor preset: enabled)
     Active: active (running) since Fri 2021-12-03 07:08:52 UTC; 11min ago
   Main PID: 576 (node_exporter)
      Tasks: 5 (limit: 1071)
     Memory: 18.2M
     CGroup: /system.slice/node_exporter.service
             └─576 /usr/local/bin/node_exporter

Dec 03 07:08:52 vagrant node_exporter[576]: ts=2021-12-03T07:08:52.800Z caller=node_exporter.go:115 level=info collector=thermal_zone
Dec 03 07:08:52 vagrant node_exporter[576]: ts=2021-12-03T07:08:52.800Z caller=node_exporter.go:115 level=info collector=time
Dec 03 07:08:52 vagrant node_exporter[576]: ts=2021-12-03T07:08:52.800Z caller=node_exporter.go:115 level=info collector=timex
Dec 03 07:08:52 vagrant node_exporter[576]: ts=2021-12-03T07:08:52.800Z caller=node_exporter.go:115 level=info collector=udp_queues
Dec 03 07:08:52 vagrant node_exporter[576]: ts=2021-12-03T07:08:52.800Z caller=node_exporter.go:115 level=info collector=uname
Dec 03 07:08:52 vagrant node_exporter[576]: ts=2021-12-03T07:08:52.800Z caller=node_exporter.go:115 level=info collector=vmstat
Dec 03 07:08:52 vagrant node_exporter[576]: ts=2021-12-03T07:08:52.800Z caller=node_exporter.go:115 level=info collector=xfs
Dec 03 07:08:52 vagrant node_exporter[576]: ts=2021-12-03T07:08:52.800Z caller=node_exporter.go:115 level=info collector=zfs
Dec 03 07:08:52 vagrant node_exporter[576]: ts=2021-12-03T07:08:52.801Z caller=node_exporter.go:199 level=info msg="Listening on" address=:9100
Dec 03 07:08:52 vagrant node_exporter[576]: ts=2021-12-03T07:08:52.817Z caller=tls_config.go:195 level=info msg="TLS is disabled." http2=false

root@vagrant:~# systemctl edit node_exporter
root@vagrant:~# cat /etc/systemd/system/node_exporter.service.d/override.conf 
[Service]
ExecStart=
ExecStart=/usr/local/bin/node_exporter --collector.disable-defaults --collector.cpu --collector.meminfo --collector.diskstats --collector.netdev

root@vagrant:~# systemctl restart node_exporter
root@vagrant:~# systemctl status node_exporter
● node_exporter.service - Node Exporter
     Loaded: loaded (/etc/systemd/system/node_exporter.service; enabled; vendor preset: enabled)
    Drop-In: /etc/systemd/system/node_exporter.service.d
             └─override.conf
     Active: active (running) since Fri 2021-12-03 09:16:08 UTC; 1s ago
   Main PID: 1988 (node_exporter)
      Tasks: 5 (limit: 1071)
     Memory: 2.0M
     CGroup: /system.slice/node_exporter.service
             └─1988 /usr/local/bin/node_exporter --collector.disable-defaults --collector.cpu --collector.meminfo --collector.diskstats --collector.netdev

Dec 03 09:16:08 vagrant systemd[1]: Started Node Exporter.
Dec 03 09:16:08 vagrant node_exporter[1988]: ts=2021-12-03T09:16:08.374Z caller=node_exporter.go:182 level=info msg="Starting node_exporter" version="(version=1.3.0, >
Dec 03 09:16:08 vagrant node_exporter[1988]: ts=2021-12-03T09:16:08.375Z caller=node_exporter.go:183 level=info msg="Build context" build_context="(go=go1.17.3, user=>
Dec 03 09:16:08 vagrant node_exporter[1988]: ts=2021-12-03T09:16:08.375Z caller=node_exporter.go:108 level=info msg="Enabled collectors"
Dec 03 09:16:08 vagrant node_exporter[1988]: ts=2021-12-03T09:16:08.375Z caller=node_exporter.go:115 level=info collector=cpu
Dec 03 09:16:08 vagrant node_exporter[1988]: ts=2021-12-03T09:16:08.375Z caller=node_exporter.go:115 level=info collector=diskstats
Dec 03 09:16:08 vagrant node_exporter[1988]: ts=2021-12-03T09:16:08.376Z caller=node_exporter.go:115 level=info collector=meminfo
Dec 03 09:16:08 vagrant node_exporter[1988]: ts=2021-12-03T09:16:08.376Z caller=node_exporter.go:115 level=info collector=netdev
Dec 03 09:16:08 vagrant node_exporter[1988]: ts=2021-12-03T09:16:08.376Z caller=node_exporter.go:199 level=info msg="Listening on" address=:9100
Dec 03 09:16:08 vagrant node_exporter[1988]: ts=2021-12-03T09:16:08.380Z caller=tls_config.go:195 level=info msg="TLS is disabled." http2=false
```




1. Ознакомьтесь с опциями node_exporter и выводом `/metrics` по-умолчанию. Приведите несколько опций, которые вы бы выбрали для базового мониторинга хоста по CPU, памяти, диску и сети.

```bash
usr/local/bin/node_exporter --collector.disable-defaults --collector.cpu --collector.meminfo --collector.diskstats --collector.netdev
```

1. Установите в свою виртуальную машину [Netdata](https://github.com/netdata/netdata). Воспользуйтесь [готовыми пакетами](https://packagecloud.io/netdata/netdata/install) для установки (`sudo apt install -y netdata`). После успешной установки:
    * в конфигурационном файле `/etc/netdata/netdata.conf` в секции [web] замените значение с localhost на `bind to = 0.0.0.0`,
    * добавьте в Vagrantfile проброс порта Netdata на свой локальный компьютер и сделайте `vagrant reload`:

    ```bash
    config.vm.network "forwarded_port", guest: 19999, host: 19999
    ```

    После успешной перезагрузки в браузере *на своем ПК* (не в виртуальной машине) вы должны суметь зайти на `localhost:19999`. Ознакомьтесь с метриками, которые по умолчанию собираются Netdata и с комментариями, которые даны к этим метрикам.

```bash
vagrant@vagrant:~$ netdata -v
netdata v1.19.0

user@acer-r:~$ curl computer-v:19999/version.txt
1.19.0-3ubuntu1
user@acer-r:~$
```


1. Можно ли по выводу `dmesg` понять, осознает ли ОС, что загружена не на настоящем оборудовании, а на системе виртуализации?

Да, можно.

```bash
vagrant@vagrant:~$ dmesg -T | grep -i virt
[Fri Dec  3 09:24:23 2021] DMI: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[Fri Dec  3 09:24:23 2021] CPU MTRRs all blank - virtualized system.
[Fri Dec  3 09:24:23 2021] Booting paravirtualized kernel on KVM
[Fri Dec  3 09:24:26 2021] systemd[1]: Detected virtualization oracle.
vagrant@vagrant:~$
```
1. Как настроен sysctl `fs.nr_open` на системе по-умолчанию? Узнайте, что означает этот параметр. Какой другой существующий лимит не позволит достичь такого числа (`ulimit --help`)?

```bash
user@computer-v:~/vagrant$ sysctl fs.nr_open
fs.nr_open = 1048576
```

       /proc/sys/fs/nr_open (since Linux 2.6.25)
              This file imposes ceiling on the value to which the RLIMIT_NOFILE resource limit can be raised (see getrlimit(2)).  This  ceiling  is  enforced  for
              both unprivileged and privileged process.  The default value in this file is 1048576.  (Before Linux 2.6.25, the ceiling for RLIMIT_NOFILE was hard-
              coded to the same value.)

```bash
vagrant@vagrant:~$ ulimit -n
1024
vagrant@vagrant:~$ ulimit -n -H
1048576
```

1. Запустите любой долгоживущий процесс (не `ls`, который отработает мгновенно, а, например, `sleep 1h`) в отдельном неймспейсе процессов; покажите, что ваш процесс работает под PID 1 через `nsenter`. Для простоты работайте в данном задании под root (`sudo -i`). Под обычным пользователем требуются дополнительные опции (`--map-root-user`) и т.д.

```bash
root@vagrant:~# unshare -f --pid --mount-proc /usr/bin/sleep 1h &
[1] 1392
root@vagrant:~# ps aux | grep sleep
root        1392  0.0  0.0   8080   592 pts/0    S    10:39   0:00 unshare -f --pid --mount-proc /usr/bin/sleep 1h
root        1393  0.0  0.0   8076   588 pts/0    S    10:39   0:00 /usr/bin/sleep 1h
root        1395  0.0  0.0   8900   668 pts/0    S+   10:39   0:00 grep --color=auto sleep
root@vagrant:~# nsenter -t 1393 -m -p
root@vagrant:/# ps aux
USER         PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root           1  0.0  0.0   8076   588 pts/0    S    10:39   0:00 /usr/bin/sleep 1h
root           2  0.0  0.4   9836  4124 pts/0    S    10:39   0:00 -bash
root          12  0.0  0.3  11492  3376 pts/0    R+   10:40   0:00 ps aux
root@vagrant:/#
```

1. Найдите информацию о том, что такое `:(){ :|:& };:`. Запустите эту команду в своей виртуальной машине Vagrant с Ubuntu 20.04 (**это важно, поведение в других ОС не проверялось**). Некоторое время все будет "плохо", после чего (минуты) – ОС должна стабилизироваться. Вызов `dmesg` расскажет, какой механизм помог автоматической стабилизации. Как настроен этот механизм по-умолчанию, и как изменить число процессов, которое можно создать в сессии?

Это функция, которая параллельно пускает два своих экземпляра. Каждый пускает ещё по два и т.д.

```bash
:()
{
    :|:&
};
:
```
Или

```bash
forkbomb()
{
    forkbomb | forkbomb &
};
forkbomb
``` 

```bash
[Dec 3 10:58] cgroup: fork rejected by pids controller in /user.slice/user-1000.slice/session-5.scope

vagrant@vagrant:~$ ulimit -u
3571

      -u        the maximum number of user processes
```


## Как сдавать задания

Обязательными к выполнению являются задачи без указания звездочки. Их выполнение необходимо для получения зачета и диплома о профессиональной переподготовке.

Задачи со звездочкой (*) являются дополнительными задачами и/или задачами повышенной сложности. Они не являются обязательными к выполнению, но помогут вам глубже понять тему.

Домашнее задание выполните в файле readme.md в github репозитории. В личном кабинете отправьте на проверку ссылку на .md-файл в вашем репозитории.

Также вы можете выполнить задание в [Google Docs](https://docs.google.com/document/u/0/?tgif=d) и отправить в личном кабинете на проверку ссылку на ваш документ.
Название файла Google Docs должно содержать номер лекции и фамилию студента. Пример названия: "1.1. Введение в DevOps — Сусанна Алиева".

Если необходимо прикрепить дополнительные ссылки, просто добавьте их в свой Google Docs.

Перед тем как выслать ссылку, убедитесь, что ее содержимое не является приватным (открыто на комментирование всем, у кого есть ссылка), иначе преподаватель не сможет проверить работу. Чтобы это проверить, откройте ссылку в браузере в режиме инкогнито.

[Как предоставить доступ к файлам и папкам на Google Диске](https://support.google.com/docs/answer/2494822?hl=ru&co=GENIE.Platform%3DDesktop)

[Как запустить chrome в режиме инкогнито ](https://support.google.com/chrome/answer/95464?co=GENIE.Platform%3DDesktop&hl=ru)

[Как запустить  Safari в режиме инкогнито ](https://support.apple.com/ru-ru/guide/safari/ibrw1069/mac)

Любые вопросы по решению задач задавайте в чате Slack.

---

