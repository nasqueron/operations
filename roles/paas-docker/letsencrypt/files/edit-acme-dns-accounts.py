#!/usr/bin/env python3
# -*- coding: utf-8 -*-

#   -------------------------------------------------------------
#   Let's encrypt — ACME DNS server accounts editor
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2020-02-22
#   Description:    Edit /srv/letsencrypt/etc/acmedns.json to import
#                   credentials for a specific subdomain to verify.
#   License:        BSD-2-Clause
#   -------------------------------------------------------------


import json
import os
import sys


def get_acme_accounts_path():
    try:
        return os.environ["ACME_ACCOUNTS"]
    except KeyError:
        return "/srv/letsencrypt/etc/acmedns.json"


ACME_ACCOUNTS_PATH = get_acme_accounts_path()


class AcmeAccounts:
    def __init__(self, path):
        self.path = path
        self.accounts = {}

    def read_from_file(self):
        with open(self.path) as fd:
            self.accounts = json.load(fd)

        return self

    def write_to_file(self):
        with open(self.path, "w") as fd:
            json.dump(self.accounts, fd)

        return self

    def add(self, domain, account_parameters):
        self.accounts[domain] = account_parameters

        return self

    def remove(self, domain):
        try:
            del self.accounts[domain]
            return True
        except KeyError:
            return False

    def merge_with(self, other_accounts: 'AcmeAccounts'):
        self.accounts.update(other_accounts.accounts)

        return self


def usage():
    print(f"Usage: {sys.argv[0]} <command> [parameters]", file=sys.stderr)
    exit(1)


def import_other_file(file_to_import):
    if file_to_import == ACME_ACCOUNTS_PATH:
        print(f"You're trying to import {ACME_ACCOUNTS_PATH} to itself")
        exit(2)

    accounts_to_import = AcmeAccounts(file_to_import).read_from_file()

    AcmeAccounts(ACME_ACCOUNTS_PATH)\
        .read_from_file()\
        .merge_with(accounts_to_import)\
        .write_to_file()


commands = {
    "import": {
        "required_argc": 3,
        "command_usage": "import <file>",
        "callable": import_other_file
    },
},


if __name__ == "__main__":
    argc = len(sys.argv)

    if argc < 2 or sys.argv[1] in ["-h", "--help", "/?", "/help"]:
        usage()

    command = sys.argv[1]

    if command not in commands:
        print(f"Unknown command: {command}", file=sys.stderr)
        usage()

    command = commands[command]

    if argc < command["required_argc"]:
        print(f"Usage: {sys.argv[0]} {command['command_usage']}", file=sys.stderr)
        exit(1)

    # We're good, time to invoke our command
    command["callable"](*sys.argv[2:])
