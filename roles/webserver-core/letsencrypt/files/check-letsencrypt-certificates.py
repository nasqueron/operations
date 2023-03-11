#!/usr/bin/env python3
# -*- coding: utf-8 -*-

#   -------------------------------------------------------------
#   Let's encrypt — Certificates web server configuration checker
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2016-06-05
#   Description:    Check if /.well-known/acme-challenge works
#                   for the mapping directory webserver for each
#                   certificate to renew.
#   License:        BSD-2-Clause
#   Source file:    roles/webserver-core/letsencrypt/files/check-letsencrypt-certificates.py
#   -------------------------------------------------------------

#   -------------------------------------------------------------
#   Table of contents
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#
#   :: Configuration
#   :: Checker code
#   :: Run task
#
#   -------------------------------------------------------------


import os
import random
import string
from urllib.error import HTTPError
from urllib.request import urlopen

#   -------------------------------------------------------------
#   Configuration
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


dirs = {
    "/usr/local/etc/letsencrypt/renewal",
    "/srv/data/letsencrypt/etc/renewal",
}


#   -------------------------------------------------------------
#   Checker code
#   -------------------------------------------------------------


def check_directories(directories):
    for directory in directories:
        if os.path.isdir(directory):
            check_directory(directory)


def check_directory(directory):
    for file in os.listdir(directory):
        if file.endswith(".conf"):
            fullpath = os.path.join(directory, file)
            check_certificate(fullpath)


def check_certificate(file):
    lines = [line.rstrip("\n") for line in open(file)]
    skip = True
    for line in lines:
        if not skip:
            check_mapping_line(line)
        if line == "[[webroot_map]]":
            skip = False


def check_mapping_line(line):
    params = line.split(" = ")
    check_mapping(params[0], params[1])


def get_challenge():
    chars = string.ascii_letters + string.digits
    return "".join([random.choice(chars) for _ in range(32)])


def check_mapping(domain, directory):
    challenge = get_challenge()
    write_challenge_file(directory, challenge)
    check_challenge(domain, challenge)


def write_challenge_file(directory, challenge):
    challenge_file = os.path.join(directory, ".well-known", "acme-challenge", "qa")
    with open(challenge_file, "w") as file:
        file.write(challenge)


def check_challenge(domain, challenge):
    url = "http://" + domain + "/.well-known/acme-challenge/qa"
    try:
        content = urlopen(url).read()
        if not content == challenge:
            print(domain, "DOES NOT MATCH")
    except HTTPError as err:
        print(domain, err.code)


#   -------------------------------------------------------------
#   Run task
#   -------------------------------------------------------------


check_directories(dirs)
