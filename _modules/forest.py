# -*- coding: utf-8 -*-

#   -------------------------------------------------------------
#   Salt — Forest execution module
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2017-10-11
#   Description:    Functions related to forests
#   License:        BSD-2-Clause
#   -------------------------------------------------------------


def exists(forest):
    """
    A function to check if a forest exists.

    CLI Example::

        salt '*' forest.exists eglide
    """
    return forest in __pillar__.get('forests', [])


def get():
    """
    A function to get the forest of the current minion

    CLI Example::

        salt '*' forest.get
    """
    nodes = __pillar__.get('nodes')
    minion = __grains__['id']
    return nodes[minion]['forest']


def list_groups(forest=None):
    """
    A function to list groups for a forest.

    CLI Example::

        salt '*' forest.list_groups
    """
    if forest is None:
        forest = get()

    groups = __pillar__.get('shellgroups_ubiquity', [])

    groupsByForest = __pillar__.get('shellgroups_by_forest', {})
    if forest in groupsByForest:
        groups.extend(groupsByForest[forest])

    return groups


def get_groups(forest=None):
    '''
    A function to get groups for a forest as a dictionary,
    including the group properties.

    CLI Example::

        salt '*' forest.get_groups
    '''
    groups = {}

    for groupname in list_groups(forest):
        groups[groupname] = __pillar__['shellgroups'][groupname]

    return groups


def list_users(forest=None):
    """
    A function to list groups for a forest.

    CLI Example::

        salt '*' forest.list_users
    """
    users = []

    for group in get_groups(forest).values():
        if "members" in group:
            users.extend(group['members'])

    return list(set(users))


def get_users(forest=None):
    """
    A function to get users for a forest as a dictionary,
    including the users properties.

    CLI Example::

        salt '*' forest.get_users
    """
    users = {}

    for username in list_users(forest):
        users[username] = __pillar__['shellusers'][username]

    return users
