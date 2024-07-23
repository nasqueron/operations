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


def list_images():
    """
    A function to get the list of images used on a Docker engine.

    Example:

        salt docker-002 paas_docker.list_images
    """
    images = __pillar__.get("docker_images", [])

    # Workaround for a merge issue for lists:
    # Salt Tower concatenates them, a set will dedup them.
    return set(images)


def get_subnets():
    """
    A function to get the Docker subnets list.

    CLI Example:

        salt * paas_docker.get_subnets
    """
    try:
        networks = __pillar__["docker_networks"]
    except KeyError:
        networks = {}

    # Defined Docker subnet
    subnets = [network["subnet"] for network in networks.values()]
    # Default Docker subnet
    subnets.append("172.17.0.0/16")

    return subnets


def _get_containers():
    try:
        return __pillar__["docker_containers"]
    except KeyError:
        return {}


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
#   Docker configuration
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


def build_daemon_config():
    network = __salt__["node.resolve_network"]()

    config = __pillar__.get("docker_daemon", {})
    config["metrics-addr"] = network["private_ipv4_address"] + ":9323"

    return config


#   -------------------------------------------------------------
#   Nginx
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


def resolve_vhost_config_file(service, dir="roles/paas-docker/nginx/files/vhosts"):
    candidate = f"{dir}/{service}.conf"

    if __salt__["slsutil.file_exists"](candidate):
        return candidate

    return f"{dir}/_default.conf"


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


#   -------------------------------------------------------------
#   Format
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


def format_env_list(values, separator=",", assign_op="-"):
    return separator.join([f"{k}{assign_op}{v}" for k, v in values.items()])
