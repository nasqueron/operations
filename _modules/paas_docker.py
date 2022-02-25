# -*- coding: utf-8 -*-

#   -------------------------------------------------------------
#   Salt — PaaS Docker execution module
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2018-10-07
#   Description:    Functions related to data format conversions
#   License:        BSD-2-Clause
#   -------------------------------------------------------------


def get_image(default_image, args):
    """
    A function to output a pillar key in JSON.

    State Example::

        {% image = salt['paas_docker.get_image']("nasqueron/mysql", container) %}
    """
    image = default_image

    if "image" in args:
        image = args["image"]

    if "version" in args:
        image += ":" + str(args["version"])

    return image


def get_subnets():
    """
    A function to get the Docker subnets list.

    CLI Example:

        salt * paas_docker.get_subnets
    """
    try:
        networks = __pillar__["docker_networks"][__grains__["id"]]
    except KeyError:
        networks = {}

    # Defined Docker subnet
    subnets = [network["subnet"] for network in networks.values()]
    # Default Docker subnet
    subnets.append("172.17.0.0/16")

    return subnets
