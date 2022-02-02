# Домашнее задание к занятию "3.8. Компьютерные сети, лекция 3"

1. Подключитесь к публичному маршрутизатору в интернет. Найдите маршрут к вашему публичному IP
```
telnet route-views.routeviews.org
Username: rviews
show ip route x.x.x.x/32
show bgp x.x.x.x/32
```

```
route-views>show ip route 94.140.145.66   
Routing entry for 94.140.145.0/24
  Known via "bgp 6447", distance 20, metric 0
  Tag 2497, type external
  Last update from 202.232.0.2 1w5d ago
  Routing Descriptor Blocks:
  * 202.232.0.2, from 202.232.0.2, 1w5d ago
      Route metric is 0, traffic share count is 1
      AS Hops 3
      Route tag 2497
      MPLS label: none
route-views>show bgp 94.140.145.66
BGP routing table entry for 94.140.145.0/24, version 285462
Paths: (22 available, best #21, table default)
  Not advertised to any peer
  Refresh Epoch 1
  6939 8359 25086
    64.71.137.241 from 64.71.137.241 (216.218.252.164)
      Origin IGP, localpref 100, valid, external
      path 7FE165919550 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  3303 8359 25086
    217.192.89.50 from 217.192.89.50 (138.187.128.158)
      Origin IGP, localpref 100, valid, external
      Community: 3303:1004 3303:1006 3303:1030 3303:3054 8359:5500 8359:55566
      path 7FE0DC5FA3D0 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  701 3356 8359 25086
    137.39.3.55 from 137.39.3.55 (137.39.3.55)
      Origin IGP, localpref 100, valid, external
      path 7FE003969A28 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  20912 3257 3356 8359 25086
    212.66.96.126 from 212.66.96.126 (212.66.96.126)
      Origin IGP, localpref 100, valid, external
      Community: 3257:8070 3257:30515 3257:50001 3257:53900 3257:53902 20912:65004
      path 7FE100932110 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  3333 8359 25086
    193.0.0.56 from 193.0.0.56 (193.0.0.56)
      Origin IGP, localpref 100, valid, external
      Community: 8359:5500 8359:55566
      path 7FE086DC2E78 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  7018 3356 8359 25086
    12.0.1.63 from 12.0.1.63 (12.0.1.63)
      Origin IGP, localpref 100, valid, external
      Community: 7018:5000 7018:37232
      path 7FE110C4D310 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  57866 3356 8359 25086
    37.139.139.17 from 37.139.139.17 (37.139.139.17)
      Origin IGP, metric 0, localpref 100, valid, external
      Community: 3356:2 3356:100 3356:123 3356:507 3356:903 3356:2111 8359:5500 8359:55566
      path 7FE1734F9E48 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  3561 3910 3356 8359 25086
    206.24.210.80 from 206.24.210.80 (206.24.210.80)
      Origin IGP, localpref 100, valid, external
      path 7FE177FDE630 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  1351 8359 25086
    132.198.255.253 from 132.198.255.253 (132.198.255.253)
      Origin IGP, localpref 100, valid, external
      path 7FE0EA804108 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 2
  8283 8359 25086
    94.142.247.3 from 94.142.247.3 (94.142.247.3)
      Origin IGP, metric 0, localpref 100, valid, external
      Community: 8283:1 8283:101 8359:5500 8359:55566
      unknown transitive attribute: flag 0xE0 type 0x20 length 0x18
        value 0000 205B 0000 0000 0000 0001 0000 205B
              0000 0005 0000 0001 
      path 7FE169A13AD0 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  852 3356 8359 25086
    154.11.12.212 from 154.11.12.212 (96.1.209.43)
      Origin IGP, metric 0, localpref 100, valid, external
      path 7FE0D79D72E8 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  20130 6939 8359 25086
    140.192.8.16 from 140.192.8.16 (140.192.8.16)
      Origin IGP, localpref 100, valid, external
      path 7FE08EFE7BB8 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  4901 6079 8359 25086
    162.250.137.254 from 162.250.137.254 (162.250.137.254)
      Origin IGP, localpref 100, valid, external
      Community: 65000:10100 65000:10300 65000:10400
      path 7FE0D4C74F50 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  53767 14315 6453 6453 3356 8359 25086
    162.251.163.2 from 162.251.163.2 (162.251.162.3)
      Origin IGP, localpref 100, valid, external
      Community: 14315:5000 53767:5000
      path 7FE0B117C248 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  3549 3356 8359 25086
    208.51.134.254 from 208.51.134.254 (67.16.168.191)
      Origin IGP, metric 0, localpref 100, valid, external
      Community: 3356:2 3356:100 3356:123 3356:507 3356:903 3356:2111 3549:2581 3549:30840 8359:5500 8359:55566
      path 7FE14D424B00 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  3356 8359 25086
    4.68.4.46 from 4.68.4.46 (4.69.184.201)
      Origin IGP, metric 0, localpref 100, valid, external
      Community: 3356:2 3356:100 3356:123 3356:507 3356:903 3356:2111 8359:5500 8359:55566
      path 7FE03A6A40F0 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  7660 2516 1299 8359 25086
    203.181.248.168 from 203.181.248.168 (203.181.248.168)
      Origin IGP, localpref 100, valid, external
      Community: 2516:1030 7660:9003
      path 7FE18CD11DA8 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  3257 3356 8359 25086
    89.149.178.10 from 89.149.178.10 (213.200.83.26)
      Origin IGP, metric 10, localpref 100, valid, external
      Community: 3257:8794 3257:30043 3257:50001 3257:54900 3257:54901
      path 7FE1118B8E38 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  49788 12552 8359 25086
    91.218.184.60 from 91.218.184.60 (91.218.184.60)
      Origin IGP, localpref 100, valid, external
      Community: 12552:12000 12552:12100 12552:12101 12552:22000
      Extended Community: 0x43:100:1
      path 7FE0E6BCDF50 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  101 3356 8359 25086
    209.124.176.223 from 209.124.176.223 (209.124.176.223)
      Origin IGP, localpref 100, valid, external
      Community: 101:20100 101:20110 101:22100 3356:2 3356:100 3356:123 3356:507 3356:903 3356:2111 8359:5500 8359:55566
      Extended Community: RT:101:22100
      path 7FE184C68E48 RPKI State not found
      rx pathid: 0, tx pathid: 0
  Refresh Epoch 1
  2497 8359 25086
    202.232.0.2 from 202.232.0.2 (58.138.96.254)
      Origin IGP, localpref 100, valid, external, best
      path 7FE10A45DCD0 RPKI State not found
      rx pathid: 0, tx pathid: 0x0
  Refresh Epoch 1
  1221 4637 3356 8359 25086
    203.62.252.83 from 203.62.252.83 (203.62.252.83)
      Origin IGP, localpref 100, valid, external
      path 7FE12C2DADF0 RPKI State not found
      rx pathid: 0, tx pathid: 0
route-views>quit
```

2. Создайте dummy0 интерфейс в Ubuntu. Добавьте несколько статических маршрутов. Проверьте таблицу маршрутизации.

```bash
root@acer-r:~# modprobe -v dummy
insmod /lib/modules/5.11.0-49-generic/kernel/drivers/net/dummy.ko numdummies=0
root@acer-r:~# ip -br link
lo               UNKNOWN        00:00:00:00:00:00 <LOOPBACK,UP,LOWER_UP> 
enp1s0           DOWN           98:29:a6:47:61:cc <NO-CARRIER,BROADCAST,MULTICAST,UP> 
wlp2s0           UP             d4:25:8b:83:b3:87 <BROADCAST,MULTICAST,UP,LOWER_UP> 
dummy0           DOWN           4e:a2:ac:4f:3a:9b <BROADCAST,NOARP>
root@acer-r:~# ip addr add 192.168.10.10/24 dev dummy0
root@acer-r:~# ip link set dev dummy0 up
root@acer-r:~# ip -br addr sh
lo               UNKNOWN        127.0.0.1/8 ::1/128 
enp1s0           DOWN           
wlp2s0           UP             192.168.1.140/24 fe80::5908:e47e:9cf9:3fa1/64 
dummy0           UNKNOWN        192.168.10.10/24 fe80::4ca2:acff:fe4f:3a9b/64
root@acer-r:~# ip route add 192.168.11.0/24 via 192.168.10.10
root@acer-r:~# ip route add 192.168.12.0/24 via 192.168.10.10
root@acer-r:~# ip ro sh
default via 192.168.1.1 dev wlp2s0 proto dhcp metric 600 
169.254.0.0/16 dev wlp2s0 scope link metric 1000 
192.168.1.0/24 dev wlp2s0 proto kernel scope link src 192.168.1.140 metric 600 
192.168.10.0/24 dev dummy0 proto kernel scope link src 192.168.10.10 
192.168.11.0/24 via 192.168.10.10 dev dummy0 
192.168.12.0/24 via 192.168.10.10 dev dummy0
```



3. Проверьте открытые TCP порты в Ubuntu, какие протоколы и приложения используют эти порты? Приведите несколько примеров.

```
root@acer-r:~# ss -lp4nt
Netid       State        Recv-Q        Send-Q               Local Address:Port                Peer Address:Port       Process                                          
tcp         LISTEN       0             4096                 127.0.0.53%lo:53                       0.0.0.0:*           users:(("systemd-resolve",pid=626,fd=13))       
tcp         LISTEN       0             128                      127.0.0.1:631                      0.0.0.0:*           users:(("cupsd",pid=21156,fd=7))
```

127.0.0.1:631 - Web интерфейс CUPS, протокол tcp

127.0.0.53%lo:53 - служба systemd, выполняющая разрешение сетевых имён, протокол tcp


4. Проверьте используемые UDP сокеты в Ubuntu, какие протоколы и приложения используют эти порты?

```
root@acer-r:~# ss -lp4nu
State          Recv-Q         Send-Q                 Local Address:Port                   Peer Address:Port         Process                                            
UNCONN         0              0                      127.0.0.53%lo:53                          0.0.0.0:*             users:(("systemd-resolve",pid=626,fd=12))         
UNCONN         0              0                      192.168.10.10:123                         0.0.0.0:*             users:(("ntpd",pid=891,fd=25))                    
UNCONN         0              0                      192.168.1.140:123                         0.0.0.0:*             users:(("ntpd",pid=891,fd=23))                    
UNCONN         0              0                          127.0.0.1:123                         0.0.0.0:*             users:(("ntpd",pid=891,fd=18))                    
UNCONN         0              0                            0.0.0.0:123                         0.0.0.0:*             users:(("ntpd",pid=891,fd=17))                    
UNCONN         0              0                            0.0.0.0:631                         0.0.0.0:*             users:(("cups-browsed",pid=21159,fd=7))           
UNCONN         0              0                            0.0.0.0:50141                       0.0.0.0:*             users:(("avahi-daemon",pid=665,fd=14))            
UNCONN         0              0                        224.0.0.251:5353                        0.0.0.0:*             users:(("chrome",pid=1701,fd=306))                
UNCONN         0              0                        224.0.0.251:5353                        0.0.0.0:*             users:(("chrome",pid=1701,fd=294))                
UNCONN         0              0                        224.0.0.251:5353                        0.0.0.0:*             users:(("chrome",pid=1750,fd=69))                 
UNCONN         0              0                            0.0.0.0:5353                        0.0.0.0:*             users:(("avahi-daemon",pid=665,fd=12))
```

127.0.0.53%lo:53 - служба systemd, выполняющая разрешение сетевых имён, протокол udp

127.0.0.1:123 - служба времени, протокол udp

5. Используя diagrams.net, создайте L3 диаграмму вашей домашней сети или любой другой сети, с которой вы работали. 

 ---
## Задание для самостоятельной отработки (необязательно к выполнению)

6*. Установите Nginx, настройте в режиме балансировщика TCP или UDP.

7*. Установите bird2, настройте динамический протокол маршрутизации RIP.

8*. Установите Netbox, создайте несколько IP префиксов, используя curl проверьте работу API.

 ---

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

Любые вопросы по решению задач задавайте в чате учебной группы.

---

