# -*- coding: utf-8 -*-

#   -------------------------------------------------------------
#   Salt — Node execution module
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2017-10-21
#   Description:    Functions related to the nodes pillar entry
#   License:        BSD-2-Clause
#   -------------------------------------------------------------


from salt.exceptions import CommandExecutionError, SaltCloudConfigError


def _get_all_nodes():
    return __pillar__.get('nodes', {})


def get_all_properties(nodename=None):
    '''
    A function to get a node pillar configuration.

    CLI Example:

        salt * node.get_all_properties
    '''
    if nodename is None:
        nodename = __grains__['id']

    all_nodes = _get_all_nodes()

    if nodename not in all_nodes:
        raise CommandExecutionError(
            SaltCloudConfigError(
                "Node {0} not declared in pillar.".format(nodename)
            )
        )

    return all_nodes[nodename]


def get(key, nodename=None):
    '''
    A function to get a node pillar configuration key.

    CLI Example:

        salt * node.get hostname
    '''
    return _get_property(key, nodename, None)


def _explode_key(k): return k.split(':')


def _get_first_key(k): return _explode_key(k)[0]


def _strip_first_key(k): return ':'.join(_explode_key(k)[1:])


def _get_property(key, nodename, default_value, parent=None):
    if parent is None:
        parent = get_all_properties(nodename)

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
    value = _get_property(key, nodename, False)
    return bool(value)


def has_role(role, nodename=None):
    '''
    A function to determine if a node has the specified role.

    Returns a boolean, False if not found.

    CLI Example:

        salt * node.has_role devserver
    '''
    return role in list('roles', nodename)
