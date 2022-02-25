# -*- coding: utf-8 -*-

#   -------------------------------------------------------------
#   Salt — Jails execution module
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2017-10-21
#   Description:    Functions related to FreeBSD jails
#   License:        BSD-2-Clause
#   -------------------------------------------------------------


import errno


def _get_all_jails():
    return __pillar__.get("jails", {})


def _get_default_group():
    """
    Gets the default group to use as key to
    the pillar's jails dictionary.
    """
    return __grains__["id"]


def list(group=None):
    """
    A function to list the jails for the specified group.

    CLI Example::

        salt '*' jails.list
    """
    all_jails = _get_all_jails()

    if group is None:
        group = _get_default_group()

    if group in all_jails:
        return all_jails[group]

    return []


def flatlist(group=None):
    """
    A function to list the jails for the specified group.

    Output is a string, ready to pass to jail_list in rc.

    CLI Example::

        salt-call --local jails.flatlist ysul
    """
    return " ".join(sorted(list(group)))


def _get_hardware_network_interfaces():
    return [interface for interface in __grains__["hwaddr_interfaces"]]


def _get_ipv6_network_interfaces():
    return [interface for interface in __grains__["ip6_interfaces"]]


def guess_ipv4_network_interface():
    """
    A function tu guess to what network interface bind the
    public IPv4 jail IP.
    """
    interfaces = _get_hardware_network_interfaces()

    if len(interfaces) < 1:
        raise OSError(errno.ENODEV, "No network interface detected.")

    # Nasqueron convention assigns the ICANN network
    # to the first card.
    return interfaces[0]


def guess_ipv6_network_interface():
    """
    A function tu guess to what network interface bind the
    public IPv6 jail IP.
    """
    interfaces = _get_ipv6_network_interfaces()

    for interface in interfaces:
        ips = __grains__["ip6_interfaces"][interface]

        # We want an interface with IPv6
        if len(ips) < 1:
            continue

        # Ignore local loopback
        if interface.startswith("lo"):
            continue

        return interface

    raise OSError(errno.EAFNOSUPPORT, "No network interface detected.")


def get(jailname, group=None):
    """
    A function to get a jail pillar configuration

    CLI Example::

        salt-call --local jails.get mumble ysul
    """
    if group is None:
        group = _get_default_group()

    all_jails = _get_all_jails()
    return all_jails[group][jailname]


def get_ezjail_ips_parameter(jailname, group=None):
    """
    A function to get the parameters to describe the jail
    IP configuration to `ezjail-admin create` command.

    CLI Example::

        salt * jails.get_ezjail_ips_parameter ftp
    """
    jail = get(jailname, group)

    config = [
        ["lo1", jail["lo"]],
        [guess_ipv4_network_interface(), jail["ipv4"]],
        [guess_ipv6_network_interface(), jail["ipv6"]],
    ]

    return ",".join(["|".join(interface) for interface in config])
