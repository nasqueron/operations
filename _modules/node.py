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
from salt._compat import ipaddress


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


def resolve_network():
    """
    A function to determine canonical properties of networks
    from the nodes pillar.

    CLI Example:
        salt * node.resolve_network
    """
    network = {
        "ipv4_address": "",
        "ipv4_gateway": "",
    }
    private_network = network.copy()

    interfaces = _get_property("network:interfaces", __grains__["id"], {})
    for interface_name, interface in interfaces.items():
        if "ipv4" not in interface:
            continue

        ipv4 = interface["ipv4"]["address"]
        if ipaddress.ip_address(ipv4).is_private:
            target = private_network
        else:
            target = network

        if target["ipv4_address"] != "":
            continue

        target["ipv4_address"] = ipv4
        try:
            target["ipv4_gateway"] = interface["ipv4"]["gateway"]
        except KeyError:
            pass

    if network["ipv4_address"] == "":
        return private_network

    return network


def _resolve_gre_tunnels_for_router(network, netmask):
    tunnels = []

    for node, tunnel in __pillar__.get(f"{network}_gre_tunnels", {}).items():
        tunnels.append(
            {
                "description": f"{network}_to_{node}",
                "interface": tunnel["router"]["interface"],
                "src": tunnel["router"]["addr"],
                "dst": tunnel["node"]["addr"],
                "netmask": netmask,
                "icann_src": get("network")["canonical_public_ipv4"],
                "icann_dst": get("network", node)["canonical_public_ipv4"],
            }
        )

    return tunnels


def resolve_gre_tunnels():
    """
    A function to get the GRE tunnels for a node

    CLI Example:
        salt * node.resolve_gre_tunnels
    """
    gre_tunnels = []

    for network, network_args in __pillar__.get("networks", {}).items():
        if __grains__["id"] == network_args["router"]:
            gre_tunnels += _resolve_gre_tunnels_for_router(
                network, network_args["netmask"]
            )
            continue

        tunnel = __salt__["pillar.get"](f"{network}_gre_tunnels:{__grains__['id']}")
        if not tunnel:
            continue

        gre_tunnels.append(
            {
                "description": f"{network}_via_{network_args['router']}",
                "interface": tunnel["node"].get("interface", "gre0"),
                "src": tunnel["node"]["addr"],
                "dst": tunnel["router"]["addr"],
                "netmask": network_args["netmask"],
                "icann_src": get("network")["canonical_public_ipv4"],
                "icann_dst": get("network", network_args["router"])[
                    "canonical_public_ipv4"
                ],
            }
        )

    return gre_tunnels
