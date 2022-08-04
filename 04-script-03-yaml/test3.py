#!/usr/bin/env python3

import socket
import json
import yaml


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

with open('fqdn_ip.json', 'w') as json_file:
    json.dump(data, json_file)

with open('fqdn_ip.yaml', 'w') as yaml_file:
    yaml.dump(data, yaml_file)

