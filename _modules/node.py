# -*- coding: utf-8 -*-

#   -------------------------------------------------------------
#   Salt — Node execution module
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2017-10-21
#   Description:    Functions related to the nodes' pillar entry
#   License:        BSD-2-Clause
#   -------------------------------------------------------------


from salt.exceptions import CommandExecutionError, SaltCloudConfigError


def _get_all_nodes():
    return __pillar__.get("nodes", {})


def get_all_properties(nodename=None):
    """
    A function to get a node pillar configuration.

    CLI Example:

        salt * node.get_all_properties
    """
    if nodename is None:
        nodename = __grains__["id"]

    all_nodes = _get_all_nodes()

    if nodename not in all_nodes:
        raise CommandExecutionError(
            SaltCloudConfigError("Node {0} not declared in pillar.".format(nodename))
        )

    return all_nodes[nodename]


def get(key, nodename=None):
    """
    A function to get a node pillar configuration key.

    CLI Example:

        salt * node.get hostname
    """
    return _get_property(key, nodename, None)


def _explode_key(k):
    return k.split(":")


def _get_first_key(k):
    return _explode_key(k)[0]


def _strip_first_key(k):
    return ":".join(_explode_key(k)[1:])


def _get_property(key, nodename, default_value, parent=None):
    if parent is None:
        parent = get_all_properties(nodename)

    if ":" in key:
        first_key = _get_first_key(key)
        if first_key in parent:
            return _get_property(
                _strip_first_key(key), nodename, default_value, parent[first_key]
            )
    elif key in parent:
        return parent[key]

    return default_value


def get_list(key, nodename=None):
    """
    A function to get a node pillar configuration.

    Returns a list if found, or an empty list if not found.

    CLI Example:

        salt * node.list network:ipv4_aliases
    """
    return _get_property(key, nodename, [])


def has(key, nodename=None):
    """
    A function to get a node pillar configuration.

    Returns a boolean, False if not found.

    CLI Example:

        salt * node.has network:ipv6_tunnel
    """
    value = _get_property(key, nodename, False)
    return bool(value)


def has_role(role, nodename=None):
    """
    A function to determine if a node has the specified role.

    Returns a boolean, False if not found.

    CLI Example:

        salt * node.has_role devserver
    """
    return role in get_list("roles", nodename)


def filter_by_role(pillar_key, nodename=None):
    """
    A function to filter a dictionary by roles.

    The dictionary must respect the following structure:
      - keys are role to check the current node against
      - values are list of items

    If a key '*' is also present, it will be included
    for every role.

    Returns a list, extending all the filtered lists.

    CLI Example:

        salt * node.filter_by_role web_content_sls
    """
    roles = get_list("roles", nodename)
    dictionary = __pillar__.get(pillar_key, {})
    filtered_list = []

    for role, items in dictionary.items():
        if role == "*" or role in roles:
            filtered_list.extend(items)

    return filtered_list


def filter_by_name(pillar_key, nodename=None):
    """
    A function to filter a dictionary by node name.

    The dictionary must respect the following structure:
      - keys are names to check the current node against
      - values are list of items

    If a key '*' is also present, it will be included
    for every node.

    Returns a list, extending all the filtered lists.

    CLI Example:

        salt * node.filter_by_name mars
    """
    if nodename is None:
        nodename = __grains__["id"]

    dictionary = __pillar__.get(pillar_key, {})
    filtered_list = []

    for name, items in dictionary.items():
        if name == "*" or name == nodename:
            filtered_list.extend(items)

    return filtered_list


def has_web_content(content, nodename=None):
    return content in filter_by_role("web_content_sls", nodename)


def get_wwwroot(nodename=None):
    """
    A function to determine the wwwroot folder to use.

    Returns a string depending on the FQDN.

    CLI Example:

        salt * node.get_wwwroot
    """
    hostname = _get_property("hostname", nodename, None)

    if hostname is None:
        raise CommandExecutionError(
            SaltCloudConfigError(
                "Node {0} doesn't have a hostname property".format(nodename)
            )
        )

    if hostname.count(".") < 2:
        return "wwwroot/{0}/www".format(hostname)

    fqdn = hostname.split(".")
    return "wwwroot/{1}/{0}".format(".".join(fqdn[0:-2]), ".".join(fqdn[-2:]))


def get_ipv6_list():
    """
    A function to get a list of IPv6, enclosed by [].

    Returns a string depending on the IPv6 currently assigned.

    CLI Example:

        salt * node.get_ipv6_list
    """
    ipv6 = __grains__.get("ipv6")

    return " ".join(["[" + ip + "]" for ip in ipv6])
