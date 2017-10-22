# -*- coding: utf-8 -*-

#   -------------------------------------------------------------
#   Salt — Node execution module
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2017-10-21
#   Description:    Functions related to FreeBSD jails
#   License:        BSD-2-Clause
#   -------------------------------------------------------------


def _get_all_nodes():
    return __pillar__.get('nodes', {})


def get(nodename=None):
    '''
    A function to get a node pillar configuration.

    CLI Example:

        salt * node.get
    '''
    if nodename is None:
        nodename = __grains__['id']

    all_nodes = _get_all_nodes()
    return all_nodes[nodename]


def _explode_key(k): return k.split(':')


def _get_first_key(k): return _explode_key(k)[0]


def _strip_first_key(k): return ':'.join(_explode_key(k)[1:])


def _get_property(key, nodename, default_value, parent=None):
    if parent is None:
        parent = get(nodename)

    if ':' in key:
        first_key = _get_first_key(key)
        if first_key in parent:
            return _get_property(
                _strip_first_key(key), nodename,
                default_value, parent[first_key]
            )
    elif key in parent:
        return parent[key]

    return default_value


def list(key, nodename=None):
    '''
    A function to get a node pillar configuration.

    Returns a list if found, or an empty list if not found.

    CLI Example:

        salt * node.list network:ipv4_aliases
    '''
    return _get_property(key, nodename, [])


def has(key, nodename=None):
    '''
    A function to get a node pillar configuration.

    Returns a boolean, False if not found.

    CLI Example:

        salt * node.has network:ipv6_tunnel
    '''
    return _get_property(bool(key), nodename, False)
