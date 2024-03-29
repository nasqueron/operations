#!/usr/bin/env python3

#   -------------------------------------------------------------
#   PaaS Docker
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2018-10-10
#   License:        Trivial work, not eligible to copyright
#   Source file:    roles/paas-docker/wrappers/files/pad-delete.py
#   -------------------------------------------------------------
#
#   <auto-generated>
#       This file is managed by our rOPS SaltStack repository.
#
#       Changes to this file may cause incorrect behavior
#       and will be lost if the state is redeployed.
#   </auto-generated>

from urllib.request import urlopen
import json
import sys

API_KEY_FILE = "/srv/pad/APIKEY.txt"
PAD_HOST = "pad.nasqueron.org"

# Read API key
with open(API_KEY_FILE) as api_file:
    key = api_file.read().strip()

# Fire request
url = "https://" + PAD_HOST + "/api/1/deletePad?apikey=" + key + "&padID=" + pad
contents = urlopen(url).read()

# Report result
result = json.loads(contents)
print(result["message"])

sys.exit(result["code"])
