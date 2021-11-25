# Домашнее задание к занятию "3.3. Операционные системы, лекция 1"

1. Какой системный вызов делает команда `cd`? В прошлом ДЗ мы выяснили, что `cd` не является самостоятельной  программой, это `shell builtin`, поэтому запустить `strace` непосредственно на `cd` не получится. Тем не менее, вы можете запустить `strace` на `/bin/bash -c 'cd /tmp'`. В этом случае вы увидите полный список системных вызовов, которые делает сам `bash` при старте. Вам нужно найти тот единственный, который относится именно к `cd`. Обратите внимание, что `strace` выдаёт результат своей работы в поток stderr, а не в stdout.

chdir("/tmp")

1. Попробуйте использовать команду `file` на объекты разных типов на файловой системе. Например:
    ```bash
    vagrant@netology1:~$ file /dev/tty
    /dev/tty: character special (5/0)
    vagrant@netology1:~$ file /dev/sda
    /dev/sda: block special (8/0)
    vagrant@netology1:~$ file /bin/bash
    /bin/bash: ELF 64-bit LSB shared object, x86-64
    ```
    Используя `strace` выясните, где находится база данных `file` на основании которой она делает свои догадки.

/usr/share/misc/magic.mgc


1. Предположим, приложение пишет лог в текстовый файл. Этот файл оказался удален (deleted в lsof), однако возможности сигналом сказать приложению переоткрыть файлы или просто перезапустить приложение – нет. Так как приложение продолжает писать в удаленный файл, место на диске постепенно заканчивается. Основываясь на знаниях о перенаправлении потоков предложите способ обнуления открытого удаленного файла (чтобы освободить место на файловой системе).

root@vagrant:~# dd if=/dev/sda of=/tmp/test.log bs=1 &
[1] 3319
root@vagrant:~# rm -f /tmp/test.log 
root@vagrant:~# lsof | grep deleted
dd        3319                          root    1w      REG              253,0   7747900    3670028 /tmp/test.log (deleted)
root@vagrant:~# echo > /proc/3319/fd/1
root@vagrant:~# kill 3319

1. Занимают ли зомби-процессы какие-то ресурсы в ОС (CPU, RAM, IO)?

Зомби не занимают памяти (как процессы-сироты), но блокируют записи в таблице процессов, размер которой ограничен для каждого пользователя и системы в целом.

1. В iovisor BCC есть утилита `opensnoop`:
    ```bash
    root@vagrant:~# dpkg -L bpfcc-tools | grep sbin/opensnoop
    /usr/sbin/opensnoop-bpfcc
    ```
    На какие файлы вы увидели вызовы группы `open` за первую секунду работы утилиты? Воспользуйтесь пакетом `bpfcc-tools` для Ubuntu 20.04. Дополнительные [сведения по установке](https://github.com/iovisor/bcc/blob/master/INSTALL.md).

vagrant@vagrant:~$ sudo opensnoop-bpfcc -d 3
PID    COMM               FD ERR PATH
786    vminfo              6   0 /var/run/utmp
560    dbus-daemon        -1   2 /usr/local/share/dbus-1/system-services
560    dbus-daemon        18   0 /usr/share/dbus-1/system-services
560    dbus-daemon        -1   2 /lib/dbus-1/system-services
560    dbus-daemon        18   0 /var/lib/snapd/dbus-1/system-services/
566    irqbalance          6   0 /proc/interrupts
566    irqbalance          6   0 /proc/stat
566    irqbalance          6   0 /proc/irq/20/smp_affinity
566    irqbalance          6   0 /proc/irq/0/smp_affinity
566    irqbalance          6   0 /proc/irq/1/smp_affinity
566    irqbalance          6   0 /proc/irq/8/smp_affinity
566    irqbalance          6   0 /proc/irq/12/smp_affinity
566    irqbalance          6   0 /proc/irq/14/smp_affinity
566    irqbalance          6   0 /proc/irq/15/smp_affinity
vagrant@vagrant:~$

1. Какой системный вызов использует `uname -a`? Приведите цитату из man по этому системному вызову, где описывается альтернативное местоположение в `/proc`, где можно узнать версию ядра и релиз ОС.

Part of the utsname information is also accessible via /proc/sys/kernel/{ostype, hostname, osrelease, version, domainname}.

1. Чем отличается последовательность команд через `;` и через `&&` в bash? Например:
    ```bash
    root@netology1:~# test -d /tmp/some_dir; echo Hi
    Hi
    root@netology1:~# test -d /tmp/some_dir && echo Hi
    root@netology1:~#
    ```
; - это просто разделитель команд, echo Hi выполнится безусловно
&& - echo Hi выполнится только при условии если предыдущая команда завершилась успешно ( с нулевых кодом возврата)

    Есть ли смысл использовать в bash `&&`, если применить `set -e`?

Имеет, `set -e` служит для того что бы скрипт остановился, если возникает какая нибудь ошибка выполнения, но не работает в конструкциях с `&&`, если сбойная команда не последняя.
А оператор `&&` служит для выполнения команды справа от оператора, если команда слева от оператора завершилась с нулевым кодом возврата.

              -e      Exit  immediately if a pipeline (which may consist of a single simple command), a list, or a compound command (see SHELL GRAMMAR above), ex‐
                      its with a non-zero status.  The shell does not exit if the command that fails is part of the command list immediately following a while  or
                      until  keyword, part of the test following the if or elif reserved words, part of any command executed in a && or || list except the command
                      following the final && or ||, any command in a pipeline but the last, or if the command's return value is being inverted with !.  If a  com‐
                      pound  command other than a subshell returns a non-zero status because a command failed while -e was being ignored, the shell does not exit.
                      A trap on ERR, if set, is executed before the shell exits.  This option applies to the shell environment and each subshell environment sepa‐
                      rately (see COMMAND EXECUTION ENVIRONMENT above), and may cause subshells to exit before executing all the commands in the subshell.

                      If  a  compound command or shell function executes in a context where -e is being ignored, none of the commands executed within the compound
                      command or function body will be affected by the -e setting, even if -e is set and a command returns a failure status.  If a  compound  com‐
                      mand  or  shell  function sets -e while executing in a context where -e is ignored, that setting will not have any effect until the compound
                      command or the command containing the function call completes.

1. Из каких опций состоит режим bash `set -euxo pipefail` и почему его хорошо было бы использовать в сценариях?

set -e - Описано выше

              -u      Treat unset variables and parameters other than the special parameters "@" and "*" as an error when performing parameter expansion.  If  ex‐
                      pansion  is  attempted  on an unset variable or parameter, the shell prints an error message, and, if not interactive, exits with a non-zero
                      status.

              -x      After expanding each simple command, for command, case command, select command, or arithmetic for command, display  the  expanded  value  of
                      PS4, followed by the command and its expanded arguments or associated word list.

              -o      pipefail
                              If  set,  the return value of a pipeline is the value of the last (rightmost) command to exit with a non-zero status, or zero if all
                              commands in the pipeline exit successfully.  This option is disabled by default.

Облегчает отладку, выодя больше информации о выполнении скрипта и прерывая скрипт при сбое в какй либо строке скрипта.

1. Используя `-o stat` для `ps`, определите, какой наиболее часто встречающийся статус у процессов в системе. В `man ps` ознакомьтесь (`/PROCESS STATE CODES`) что значат дополнительные к основной заглавной буквы статуса процессов. Его можно не учитывать при расчете (считать S, Ss или Ssl равнозначными).

S    interruptible sleep (waiting for an event to complete)

               <    high-priority (not nice to other users)
               N    low-priority (nice to other users)
               L    has pages locked into memory (for real-time and custom IO)
               s    is a session leader
               l    is multi-threaded (using CLONE_THREAD, like NPTL pthreads do)
               +    is in the foreground process group
