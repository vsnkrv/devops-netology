1. Какого типа команда `cd`? Попробуйте объяснить, почему она именно такого типа; опишите ход своих мыслей, если считаете что она могла бы быть другого типа.

cd is a shell builtin

Команда должна быть встроенная, потому что если shell породил бы другой процесс для выполнения системного вызова chdir, он изменит каталог только для этого вновь возникшего процесса, а не для shell. Затем, когда процесс вернется, shell останется в том же каталоге, в котором он был все это время, поэтому cd должен быть реализован как встроенный shell.


2. Какая альтернатива без pipe команде `grep <some_string> <some_file> | wc -l

grep -c <some_string> <some_file>


3. Какой процесс с PID 1 является родителем для всех процессов в вашей виртуальной машине Ubuntu 20.04?

vagrant@vagrant:~$ ps -F -p 1
UID          PID    PPID  C    SZ   RSS PSR STIME TTY          TIME CMD
root           1       0  0 25485 11296   0 11:52 ?        00:00:01 /sbin/init


4. Как будет выглядеть команда, которая перенаправит вывод stderr ls на другую сессию терминала?

vagrant@vagrant:~$ tty
/dev/pts/0
vagrant@vagrant:~$ ls -la file_not_found 2>/dev/pts/1
vagrant@vagrant:~$

vagrant@vagrant:~$ tty
/dev/pts/1
vagrant@vagrant:~$ ls: cannot access 'file_not_found': No such file or directory


5. Получится ли одновременно передать команде файл на stdin и вывести ее stdout в другой файл? Приведите работающий пример.

vagrant@vagrant:~$ wc -l < /var/log/syslog > ~/syslog_count 
vagrant@vagrant:~$ cat syslog_count 
208
vagrant@vagrant:~$


6. Получится ли находясь в графическом режиме, вывести данные из PTY в какой-либо из эмуляторов TTY? Сможете ли вы наблюдать выводимые данные?

Да, echo test /dev/tty2 при условии что в этом tty залогинены под этим же пользователем.


7. Выполните команду bash 5>&1. К чему она приведет? Что будет, если вы выполните echo netology > /proc/$$/fd/5? Почему так происходит?

bash 5>&1 - создает файловый дескриптор 5 и перенаправит его в stdout
echo netology > /proc/$$/fd/5 - выводит текст netology в файловый дескриптор 5, который был пернеаправлен в stdout


8. Получится ли в качестве входного потока для pipe использовать только stderr команды, не потеряв при этом отображение stdout на pty? Напоминаем: по умолчанию через pipe передается только stdout команды слева от | на stdin команды справа. Это можно сделать, поменяв стандартные потоки местами через промежуточный новый дескриптор, который вы научились создавать в предыдущем вопросе.

vagrant@vagrant:~$ ls -l {1..10} |& tee /dev/stderr | wc -l
ls: cannot access '6': No such file or directory
ls: cannot access '7': No such file or directory
ls: cannot access '8': No such file or directory
ls: cannot access '9': No such file or directory
ls: cannot access '10': No such file or directory
-rw-rw-r-- 1 vagrant vagrant 0 Nov 22 13:42 1
-rw-rw-r-- 1 vagrant vagrant 0 Nov 22 13:42 2
-rw-rw-r-- 1 vagrant vagrant 0 Nov 22 13:42 3
-rw-rw-r-- 1 vagrant vagrant 0 Nov 22 13:42 4
-rw-rw-r-- 1 vagrant vagrant 0 Nov 22 13:42 5
10
vagrant@vagrant:~$


9. Что выведет команда cat /proc/$$/environ? Как еще можно получить аналогичный по содержанию вывод?

Выводит переменные окружения, они же могут быть получены командой env


10. Используя man, опишите что доступно по адресам /proc/<PID>/cmdline, /proc/<PID>/exe.

/proc/[pid]/cmdline
              This read-only file holds the complete command line for the process, unless the process is a zombie.  In the latter case, there is nothing  in  this
              file:  that  is, a read on this file will return 0 characters.  The command-line arguments appear in this file as a set of strings separated by null
              bytes ('\0'), with a further null byte after the last string.

/proc/[pid]/exe
              Under  Linux 2.2 and later, this file is a symbolic link containing the actual pathname of the executed command.  This symbolic link can be derefer‐
              enced normally; attempting to open it will open the executable.  You can even type /proc/[pid]/exe to run another copy of the same  executable  that
              is  being  run  by process [pid].  If the pathname has been unlinked, the symbolic link will contain the string '(deleted)' appended to the original
              pathname.  In a multithreaded process, the contents of this symbolic link are not available if the main thread has already terminated (typically  by
              calling pthread_exit(3)).

              Permission  to  dereference  or  read  (readlink(2))  this  symbolic  link  is  governed by a ptrace access mode PTRACE_MODE_READ_FSCREDS check; see
              ptrace(2).

              Under Linux 2.0 and earlier, /proc/[pid]/exe is a pointer to the binary which was executed, and appears as a symbolic link.  A readlink(2)  call  on
              this file under Linux 2.0 returns a string in the format:

                  [device]:inode

              For example, [0301]:1502 would be inode 1502 on device major 03 (IDE, MFM, etc. drives) minor 01 (first partition on the first drive).

              find(1) with the -inum option can be used to locate the file.


11. Узнайте, какую наиболее старшую версию набора инструкций SSE поддерживает ваш процессор с помощью /proc/cpuinfo.

vagrant@vagrant:~$ grep -i sse /proc/cpuinfo 
flags   : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx rdtscp lm constant_tsc rep_good nopl xtopology nonstop_tsc cpuid tsc_known_freq pni ssse3 cx16 sse4_1 sse4_2 x2apic hypervisor lahf_lm pti flush_l1d
flags   : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx rdtscp lm constant_tsc rep_good nopl xtopology nonstop_tsc cpuid tsc_known_freq pni ssse3 cx16 sse4_1 sse4_2 x2apic hypervisor lahf_lm pti flush_l1d
vagrant@vagrant:~$


12. По умолчания ssh создает tty только в интерактивном режиме, принудительно создать tty можно при помощи ключа -t

vagrant@vagrant:~$ ssh -t localhost 'tty'
vagrant@localhost's password: 
/dev/pts/2
Connection to localhost closed.
vagrant@vagrant:~$

13. 

root@vagrant:~# tty
/dev/pts/0
root@vagrant:~# watch -n 3 ls -l /var

root@vagrant:~# tty
/dev/pts/1
root@vagrant:~# ps aux | grep watch
root          85  0.0  0.0      0     0 ?        S    11:52   0:00 [watchdogd]
root        2937  0.0  0.3   9084  3272 pts/0    S+   18:19   0:00 watch -n 3 ls -l /var
root        2948  0.0  0.0   9032   724 pts/1    S+   18:20   0:00 grep --color=auto watch
root@vagrant:~# reptyr 2937


14. tee - read from standard input and write to standard output and files

Конструкция echo string | sudo tee /root/new_file работает, потому что tee запускается с правами root
