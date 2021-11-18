1. Установите средство виртуализации Oracle VirtualBox.

user@computer-v:~$ VBoxManage -v
6.1.26_Ubuntur145957


2. Установите средство автоматизации Hashicorp Vagrant.

user@computer-v:~$ vagrant version
Installed Version: 2.2.6


3. какой переменной можно задать длину журнала history, и на какой строчке manual это описывается?

HISTSIZE, на 710 строке man bash.


4. что делает директива ignoreboth в bash?

Значение ignoreboth является сокращением для ignorespace и ignoredups.


5. При необходимости выполнить одну команду для множества аргументов, например touch {1,2,3} или touch {1..3}, указано в man bash в строке 224


6. touch {1..100000}; ulimit -s unlimited; touch {1..300000}


7. [[ -d /tmp ]] True if /tmp exists and is a directory


8. mkdir /tmp/new_path_directory; ln -s /bin/bash /tmp/new_path_directory/; export PATH=/tmp/new_path_directory:$PATH


9. at -  executes commands at a specified time, batch - executes commands when system load levels permit; in other words, when the load average drops below 1.5, or the value specified in  the  invocation of atd.
