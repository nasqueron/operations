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
    return forest in __pillar__.get("forests", [])


def get():
    """
    A function to get the forest of the current minion

    CLI Example::

        salt '*' forest.get
    """
    nodes = __pillar__.get("nodes")
    minion = __grains__["id"]
    return nodes[minion]["forest"]


def list_groups(forest=None):
    """
    A function to list groups for a forest.

    CLI Example::

        salt '*' forest.list_groups
    """
    if forest is None:
        forest = get()

    groups = __pillar__.get("shellgroups_ubiquity", [])

    groups_by_forest = __pillar__.get("shellgroups_by_forest", {})
    if forest in groups_by_forest:
        groups.extend(groups_by_forest[forest])

    return groups


def get_groups(forest=None):
    """
    A function to get groups for a forest as a dictionary,
    including the group properties.

    CLI Example::

        salt '*' forest.get_groups
    """
    groups = {}

    for groupname in list_groups(forest):
        groups[groupname] = __pillar__["shellgroups"][groupname]

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
            users.extend(group["members"])

    return list(set(users))


def _get_user(forest, username):
    user = __pillar__["shellusers"][username]

    if "ssh_keys" not in user:
        user["ssh_keys"] = []

    try:
        user["ssh_keys"].extend(user["ssh_keys_by_forest"][forest])
    except KeyError:
        pass

    return user


def get_users(forest=None):
    """
    A function to get users for a forest as a dictionary,
    including the users properties.

    CLI Example::

        salt '*' forest.get_users
    """
    users = {}

    if forest is None:
        forest = get()

    for username in list_users(forest):
        users[username] = _get_user(forest, username)

    return users


def get_wheel_users():
    """
    A function to get users to provision to the wheel group.

    CLI Example::

        salt '*' forest.get_wheel_users
    """

    return ["root", *__pillar__["shellgroups"]["ops"]["members"]]
