# Домашнее задание к занятию "4.2. Использование Python для решения типовых DevOps задач"

## Обязательные задания

1. Есть скрипт:
	```python
    #!/usr/bin/env python3
	a = 1
	b = '2'
	c = a + b
	```
	* Какое значение будет присвоено переменной c?

		Будет ошибка, попытка разные типы переменных

	* Как получить для переменной c значение 12?

		c = str(a) + b

	* Как получить для переменной c значение 3?

		c = a + int(b)


1. Мы устроились на работу в компанию, где раньше уже был DevOps Engineer. Он написал скрипт, позволяющий узнать, какие файлы модифицированы в репозитории, относительно локальных изменений. Этим скриптом недовольно начальство, потому что в его выводе есть не все изменённые файлы, а также непонятен полный путь к директории, где они находятся. Как можно доработать скрипт ниже, чтобы он исполнял требования вашего руководителя?

	```python
    #!/usr/bin/env python3

    import os

	bash_command = ["cd ~/netology/sysadm-homeworks", "git status"]
	result_os = os.popen(' && '.join(bash_command)).read()
    is_change = False
	for result in result_os.split('\n'):
        if result.find('modified') != -1:
            prepare_result = result.replace('\tmodified:   ', '')
            print(prepare_result)
            break

	```

```python

#!/usr/bin/env python3

import os

repo_str = '~/devops-netology'
bash_command = ["cd " + repo_str, "git status -s"]
result_os = os.popen(' && '.join(bash_command)).read()
is_change = False
for result in result_os.split('\n'):
    if result.startswith('A  ') :
        prepare_result = repo_str + '/' + result.replace('A  ', '') + ' - file added in repository ' + repo_str
        print(prepare_result)
    if result.startswith('AM ') :
        prepare_result = repo_str + '/' + result.replace('AM ', '') + ' - file added and modify in repository ' + repo_str
        print(prepare_result)
    if result.startswith('?? ') :
        prepare_result = repo_str + '/' + result.replace('?? ', '') + ' - file not added in repository ' + repo_str
        print(prepare_result)

```


1. Доработать скрипт выше так, чтобы он мог проверять не только локальный репозиторий в текущей директории, а также умел воспринимать путь к репозиторию, который мы передаём как входной параметр. Мы точно знаем, что начальство коварное и будет проверять работу этого скрипта в директориях, которые не являются локальными репозиториями.

```python

#!/usr/bin/env python3

import os
import subprocess
import argparse

def git_status(repo_path):
    reply = subprocess.run(
        f'git status -s',
        cwd=repo_path,
        shell=True,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        encoding="utf-8",
    )
    if reply.returncode == 0:
        return True, reply.stdout
    else:
        return False, reply.stdout + reply.stderr


parser = argparse.ArgumentParser(description='git status script')

parser.add_argument('-r', dest='repo_path', default=os.getcwd(), required = False)

args = parser.parse_args()

if os.path.isdir(args.repo_path):

        repo = os.popen('git rev-parse --show-toplevel').read().rstrip('\n')
        os.chdir(args.repo_path)

        if subprocess.call(['git', 'rev-parse', '--show-toplevel'], stderr=subprocess.STDOUT, stdout = open(os.devnull, 'w')) == 0:
                rc, message = git_status(args.repo_path)

                for result in message.split('\n'):
                    if result.startswith('A  ') :
                        prepare_result = repo + '/' + result.replace('A  ', '').lstrip('../') + ' - file added in repository ' + repo
                        print(prepare_result)
                    if result.startswith('AM ') :
                        prepare_result = repo + '/' + result.replace('AM ', '').lstrip('../') + ' - file added and modify in repository ' + repo
                        print(prepare_result)
                    if result.startswith('?? ') :
                        prepare_result = repo + '/' + result.replace('?? ', '').lstrip('../') + ' - file not added in repository ' + repo
                        print(prepare_result)
        else:
                print('Directory not a git repository')

else:
        print('Directory does not exist')

```


1. Наша команда разрабатывает несколько веб-сервисов, доступных по http. Мы точно знаем, что на их стенде нет никакой балансировки, кластеризации, за DNS прячется конкретный IP сервера, где установлен сервис. Проблема в том, что отдел, занимающийся нашей инфраструктурой очень часто меняет нам сервера, поэтому IP меняются примерно раз в неделю, при этом сервисы сохраняют за собой DNS имена. Это бы совсем никого не беспокоило, если бы несколько раз сервера не уезжали в такой сегмент сети нашей компании, который недоступен для разработчиков. Мы хотим написать скрипт, который опрашивает веб-сервисы, получает их IP, выводит информацию в стандартный вывод в виде: <URL сервиса> - <его IP>. Также, должна быть реализована возможность проверки текущего IP сервиса c его IP из предыдущей проверки. Если проверка будет провалена - оповестить об этом в стандартный вывод сообщением: [ERROR] <URL сервиса> IP mismatch: <старый IP> <Новый IP>. Будем считать, что наша разработка реализовала сервисы: drive.google.com, mail.google.com, google.com.

```python

#!/usr/bin/env python3

import socket
import json


with open('fqdn_ip.txt') as json_file:
    data = json.load(json_file)

for key in data.keys():
    ip = socket.gethostbyname(key)
    if  ip == str(data[key]):
        print(data[key] + ' - ' + ip)
    else:
        print('[ERROR] ' + key + ' IP mismatch: ' + data.get(key) + ' ' + ip)
        data[key] = ip

with open('fqdn_ip.txt', 'w') as json_file:
    json.dump(data, json_file)

```

## Дополнительное задание (со звездочкой*) - необязательно к выполнению

Так получилось, что мы очень часто вносим правки в конфигурацию своей системы прямо на сервере. Но так как вся наша команда разработки держит файлы конфигурации в github и пользуется gitflow, то нам приходится каждый раз переносить архив с нашими изменениями с сервера на наш локальный компьютер, формировать новую ветку, коммитить в неё изменения, создавать pull request (PR) и только после выполнения Merge мы наконец можем официально подтвердить, что новая конфигурация применена. Мы хотим максимально автоматизировать всю цепочку действий. Для этого нам нужно написать скрипт, который будет в директории с локальным репозиторием обращаться по API к github, создавать PR для вливания текущей выбранной ветки в master с сообщением, которое мы вписываем в первый параметр при обращении к py-файлу (сообщение не может быть пустым). При желании, можно добавить к указанному функционалу создание новой ветки, commit и push в неё изменений конфигурации. С директорией локального репозитория можно делать всё, что угодно. Также, принимаем во внимание, что Merge Conflict у нас отсутствуют и их точно не будет при push, как в свою ветку, так и при слиянии в master. Важно получить конечный результат с созданным PR, в котором применяются наши изменения. 


---

### Как сдавать задания

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---
