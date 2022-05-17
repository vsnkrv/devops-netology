#!/usr/bin/env python3

import json
import sys

# load the data into an element
data={"drive.google.com" : "1.1.1.1", "mail.google.com" : "2.2.2.2", "google.com" : "3.3.3.3"}

with open('fqdn_ip.txt', 'w') as json_file:
  json.dump(data, json_file)
