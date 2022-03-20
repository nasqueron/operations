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


def _get_containers():
    return __pillar__["docker_containers"][__grains__["id"]]


def list_containers():
    """
    A function to list all the containers provisionned on a Docker engine.

    This function uses the pillar docker_containers as authoritative source,
    so it documents the expected configuration, not the actual containers
    running. That allows to compare both states.

    CLI Example:

        salt * paas_docker.list_containers
    """
    return [
        key
        for service, service_containers in _get_containers().items()
        for key in service_containers.keys()
    ]


#   -------------------------------------------------------------
#   Monitoring
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


def _get_health_check_url(check_type, container, url):
    if check_type[-6:] == "_proxy":
        return f"https://{container['host']}{url}"

    return f"http://localhost:{container['app_port']}{url}"


def get_health_checks():
    """
    A function to get a dictionary with health checks
    for known containers to use with our monitoring.

    CLI Example:

        salt * paas_docker.get_health_checks
    """
    containers = _get_containers()
    monitoring = __pillar__["docker_containers_monitoring"]

    return {
        check_type: {
            instance: _get_health_check_url(check_type, container, url)
            for service, url in monitoring[check_type].items()
            for instance, container in containers.get(service, {}).items()
        }
        for check_type in monitoring.keys()
    }
