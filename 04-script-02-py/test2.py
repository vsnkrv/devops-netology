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

