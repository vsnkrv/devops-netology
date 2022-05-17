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
