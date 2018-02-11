#!/usr/bin/env python3
#
# Guesses a free sequential user ID for a new account.
#
# To do so, reads from pillar/core/users.sls (USERS_DATASOURCE) the last users
# uid # and offers the next one available.
#
# ID > 5000 (USERS_CUT) are ignored.

import yaml


USERS_DATASOURCE = 'pillar/core/users.sls'
USERS_DATASOURCE_KEY = 'shellusers'
USERS_CUT = 5000


def get_shellusers(filename, key):
    with open(filename) as stream:
        data = yaml.load(stream)
        return data['shellusers']


def get_uids(users, threshold):
    return [users[username]['uid']
            for username in users
            if users[username]['uid'] < threshold]


users = get_shellusers(USERS_DATASOURCE, USERS_DATASOURCE_KEY)
uids = get_uids(users, USERS_CUT)
print(max(uids) + 1)
