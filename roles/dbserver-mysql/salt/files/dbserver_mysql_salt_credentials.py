#!/usr/bin/env python3

#   -------------------------------------------------------------
#   Salt - configuration
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   Source file:    roles/dbserver-mysql/salt/files/dbserver_mysql_salt_credentials.py
#   -------------------------------------------------------------
#
#   <auto-generated>
#       This file is managed by our rOPS SaltStack repository.
#
#       Changes to this file may cause incorrect behavior
#       and will be lost if the state is redeployed.
#   </auto-generated>


import os
import subprocess
import sys
import yaml


def read_config(config_path):
    with open(config_path) as fd:
        return yaml.safe_load(fd)


def prepare_query(query, config):
    query = query.replace("%%username%%", config["mysql.user"])
    query = query.replace("%%password%%", config["mysql.pass"])
    return query


def run_query(query, config):
    query = prepare_query(query, config)
    with open(".query", "w") as fd:
        fd.write(query)
    subprocess.run("mysql < .query", shell=True)
    os.remove(".query")


def provision_account(config):
    query = (
        "CREATE OR REPLACE USER %%username%%@localhost IDENTIFIED BY '%%password%%';"
    )
    run_query(query, config)

    query = (
        "GRANT ALL PRIVILEGES ON *.* TO '%%username%%'@'localhost' WITH GRANT OPTION;"
    )
    run_query(query, config)


def run(config_path):
    config = read_config(config_path)
    provision_account(config)


if __name__ == "__main__":
    argc = len(sys.argv)

    if argc < 2:
        print(f"Usage: {sys.argv[0]} <configuration path>", file=sys.stderr)
        sys.exit(1)

    run(sys.argv[1])
