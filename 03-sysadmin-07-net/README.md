# Домашнее задание к занятию "3.7. Компьютерные сети, лекция 2"

1. Проверьте список доступных сетевых интерфейсов на вашем компьютере. Какие команды есть для этого в Linux и в Windows?

*Linux*
```bash
root@acer-r:~# ip -c -br link show
lo               UNKNOWN        00:00:00:00:00:00 <LOOPBACK,UP,LOWER_UP> 
enp1s0           DOWN           98:29:a6:47:61:cc <NO-CARRIER,BROADCAST,MULTICAST,UP> 
wlp2s0           UP             d4:25:8b:83:b3:87 <BROADCAST,MULTICAST,UP,LOWER_UP> 
root@acer-r:~#
```

*Windows*
```bash
C:\Users\wrw>netsh interface show interface

Состояние адм.  Состояние     Тип              Имя интерфейса
---------------------------------------------------------------------
Разрешен       Подключен      Выделенный       Ethernet


C:\Users\wrw>
```

2. Какой протокол используется для распознавания соседа по сетевому интерфейсу? Какой пакет и команды есть в Linux для этого?

Link Layer Discovery Protocol (LLDP) — протокол канального уровня, который позволяет сетевым устройствам анонсировать в сеть информацию о себе и о своих возможностях, а также собирать эту информацию о соседних устройствах.

```bash
root@acer-r:~# apt list lldpd
Вывод списка… Готово
lldpd/hirsute,now 1.0.8-1 amd64 [установлен]
```
```bash
root@acer-r:~# lldpcli 
[lldpcli] # help

-- Help
       show  Show running system information
      watch  Monitor neighbor changes
     update  Update information and send LLDPU on all ports
  configure  Change system settings
unconfigure  Unconfigure system settings
       help  Get help on a possible command
      pause  Pause lldpd operations
     resume  Resume lldpd operations
       exit  Exit interpreter

[lldpcli] #
```

3. Какая технология используется для разделения L2 коммутатора на несколько виртуальных сетей? Какой пакет и команды есть в Linux для этого? Приведите пример конфига.

IEEE 802.1Q — открытый стандарт, который описывает процедуру тегирования трафика для передачи информации о принадлежности к VLAN по сетям стандарта IEEE 802.3 Ethernet.

```bash
root@acer-r:~# apt list vlan
Вывод списка… Готово
vlan/hirsute,hirsute,now 2.0.5ubuntu5 all [установлен]
```

```bash
root@acer-r:~# ip link add link enp1s0 name enp1s0.10 type vlan id 10
root@acer-r:~# ip -c -br link sh
lo               UNKNOWN        00:00:00:00:00:00 <LOOPBACK,UP,LOWER_UP> 
enp1s0           DOWN           98:29:a6:47:61:cc <NO-CARRIER,BROADCAST,MULTICAST,UP> 
wlp2s0           UP             d4:25:8b:83:b3:87 <BROADCAST,MULTICAST,UP,LOWER_UP> 
enp1s0.10@enp1s0 DOWN           98:29:a6:47:61:cc <BROADCAST,MULTICAST> 
root@acer-r:~# ip addr add 192.168.10.10/24 brd 192.168.10.255 dev enp1s0.10
root@acer-r:~# ip -c -br addr sh
lo               UNKNOWN        127.0.0.1/8 ::1/128 
enp1s0           DOWN           
wlp2s0           UP             192.168.1.199/24 fe80::f497:8bc7:c54c:2ab9/64 
enp1s0.10@enp1s0 DOWN           192.168.10.10/24 
root@acer-r:~#
```

4. Какие типы агрегации интерфейсов есть в Linux? Какие опции есть для балансировки нагрузки? Приведите пример конфига.

Балансировка нагрузки или резервирование каналов связи


mode=0 (balance-rr)
При этом методе объединения трафик распределяется по принципу «карусели»: пакеты по очереди направляются на сетевые карты объединённого интерфейса. Например, если у нас есть физические интерфейсы eth0, eth1, and eth2, объединенные в bond0, первый пакет будет отправляться через eth0, второй — через eth1, третий — через eth2, а четвертый снова через eth0 и т.д.

mode=2 (balance-xor)
В данном случае объединенный интерфейс определяет, через какую физическую сетевую карту отправить пакеты, в зависимости от MAC-адресов источника и получателя.

mode=3 (broadcast) Широковещательный режим, все пакеты отправляются через каждый интерфейс. Имеет ограниченное применение, но обеспечивает значительную отказоустойчивость.

mode=4 (802.3ad)
Особый режим объединения. Для него требуется специально настраивать коммутатор, к которому подключен объединенный интерфейс. Реализует стандарты объединения каналов IEEE и обеспечивает как увеличение пропускной способности, так и отказоустойчивость.

mode=5 (balance-tlb)
Распределение нагрузки при передаче. Входящий трафик обрабатывается в обычном режиме, а при передаче интерфейс определяется на основе данных о загруженности.

mode=6 (balance-alb)
Адаптивное распределение нагрузки. Аналогично предыдущему режиму, но с возможностью балансировать также входящую нагрузку.

root@vagrant:~# modprobe bonding
root@vagrant:~# ip link add bond0 type bond
root@vagrant:~# ip link set bond0 type bond miimon 100 mode balance-rr
root@vagrant:~# ip link set eth1 master bond0
root@vagrant:~# ip link set eth2 master bond0
root@vagrant:~# ip addr add 192.168.10.11/24 brd 192.168.10.255 dev bond0
root@vagrant:~# ip link set bond0 up
root@vagrant:~# cat /proc/net/bonding/bond0
Ethernet Channel Bonding Driver: v3.7.1 (April 27, 2011)

Bonding Mode: load balancing (round-robin)
MII Status: up
MII Polling Interval (ms): 100
Up Delay (ms): 0
Down Delay (ms): 0
Peer Notification Delay (ms): 0

Slave Interface: eth1
MII Status: up
Speed: 1000 Mbps
Duplex: full
Link Failure Count: 0
Permanent HW addr: 08:00:27:51:c7:22
Slave queue ID: 0

Slave Interface: eth2
MII Status: up
Speed: 1000 Mbps
Duplex: full
Link Failure Count: 0
Permanent HW addr: 08:00:27:a7:df:78
Slave queue ID: 0
root@vagrant:~#


5. Сколько IP адресов в сети с маской /29 ? Сколько /29 подсетей можно получить из сети с маской /24. Приведите несколько примеров /29 подсетей внутри сети 10.10.10.0/24.

```bash
root@acer-r:~# ipcalc 192.168.1.1/29 | grep 'Hosts/Net'
Hosts/Net: 6                     Class C, Private Internet
```

```bash
root@acer-r:~# sipcalc -s 29 192.168.1.1/24
-[ipv4 : 192.168.1.1/24] - 0

[Split network]
Network                 - 192.168.1.0     - 192.168.1.7
Network                 - 192.168.1.8     - 192.168.1.15
Network                 - 192.168.1.16    - 192.168.1.23
Network                 - 192.168.1.24    - 192.168.1.31
Network                 - 192.168.1.32    - 192.168.1.39
Network                 - 192.168.1.40    - 192.168.1.47
Network                 - 192.168.1.48    - 192.168.1.55
Network                 - 192.168.1.56    - 192.168.1.63
Network                 - 192.168.1.64    - 192.168.1.71
Network                 - 192.168.1.72    - 192.168.1.79
Network                 - 192.168.1.80    - 192.168.1.87
Network                 - 192.168.1.88    - 192.168.1.95
Network                 - 192.168.1.96    - 192.168.1.103
Network                 - 192.168.1.104   - 192.168.1.111
Network                 - 192.168.1.112   - 192.168.1.119
Network                 - 192.168.1.120   - 192.168.1.127
Network                 - 192.168.1.128   - 192.168.1.135
Network                 - 192.168.1.136   - 192.168.1.143
Network                 - 192.168.1.144   - 192.168.1.151
Network                 - 192.168.1.152   - 192.168.1.159
Network                 - 192.168.1.160   - 192.168.1.167
Network                 - 192.168.1.168   - 192.168.1.175
Network                 - 192.168.1.176   - 192.168.1.183
Network                 - 192.168.1.184   - 192.168.1.191
Network                 - 192.168.1.192   - 192.168.1.199
Network                 - 192.168.1.200   - 192.168.1.207
Network                 - 192.168.1.208   - 192.168.1.215
Network                 - 192.168.1.216   - 192.168.1.223
Network                 - 192.168.1.224   - 192.168.1.231
Network                 - 192.168.1.232   - 192.168.1.239
Network                 - 192.168.1.240   - 192.168.1.247
Network                 - 192.168.1.248   - 192.168.1.255

-
root@acer-r:~#
```

10.10.10.8/29
10.10.10.144/29
10.10.10.224/29



6. Задача: вас попросили организовать стык между 2-мя организациями. Диапазоны 10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16 уже заняты. Из какой подсети допустимо взять частные IP адреса? Маску выберите из расчета максимум 40-50 хостов внутри подсети.

100.100.100.0/26

7. Как проверить ARP таблицу в Linux, Windows? Как очистить ARP кеш полностью? Как из ARP таблицы удалить только один нужный IP?

*Linux*
```bash
root@acer-r:~# arp -an
? (192.168.1.51) в e0:cb:4e:81:69:67 [ether] на wlp2s0
? (192.168.1.1) в f0:b4:d2:41:7c:33 [ether] на wlp2s0
? (192.168.1.52) в 00:c0:ee:ad:ca:c5 [ether] на wlp2s0
root@acer-r:~#ip neigh del 192.168.1.51 lladdr e0:cb:4e:81:69:67 dev wlp2s0
root@acer-r:~# ip neigh flush all
```

*Windows*

```bash
C:\Users\wrw>netsh interface ip show neighbors

Интерфейс 1: Loopback Pseudo-Interface 1


IP-адрес                              Физический адрес   Тип
--------------------------------------------  -----------------  -----------
224.0.0.22                                                       Постоянный
239.255.255.250                                                  Постоянный

Интерфейс 5: Ethernet


IP-адрес                              Физический адрес   Тип
--------------------------------------------  -----------------  -----------
192.168.1.1                                   f0-b4-d2-41-7c-33  Пробный
192.168.1.51                                  e0-cb-4e-81-69-67  Достижимый
192.168.1.52                                  00-c0-ee-ad-ca-c5  Достижимый
192.168.1.121                                 b4-c9-b9-99-b3-a9  Устаревший
192.168.1.255                                 ff-ff-ff-ff-ff-ff  Постоянный
224.0.0.22                                    01-00-5e-00-00-16  Постоянный
224.0.0.251                                   01-00-5e-00-00-fb  Постоянный
224.0.0.252                                   01-00-5e-00-00-fc  Постоянный
239.255.255.250                               01-00-5e-7f-ff-fa  Постоянный
255.255.255.255                               ff-ff-ff-ff-ff-ff  Постоянный


C:\Users\wrw>netsh interface ip delete neighbors name=Ethernet address=192.168.1.121
Ok

C:\Users\wrw>netsh interface ip delete neighbors
Ok
```


 ---
## Задание для самостоятельной отработки (необязательно к выполнению)

 8*. Установите эмулятор EVE-ng.
 
 Инструкция по установке - https://github.com/svmyasnikov/eve-ng

 Выполните задания на lldp, vlan, bonding в эмуляторе EVE-ng. 
 
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
