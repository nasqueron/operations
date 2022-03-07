# -*- coding: utf-8 -*-

#   -------------------------------------------------------------
#   Salt — PaaS OpenSearch execution module
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Description:    Functions related to OpenSearch configuration
#   License:        BSD-2-Clause
#   -------------------------------------------------------------


from salt.exceptions import CommandExecutionError, SaltCloudConfigError


def get_config(node_name=None):
    """
    A function to get relevant values for OpenSearch configuration.

    CLI Example:

        salt * opensearch.get_config
    """
    if node_name is None:
        node_name = __grains__["id"]

    try:
        clusters = __pillar__["opensearch_clusters"]
    except KeyError:
        clusters = []

    for _, cluster in clusters.items():
        if node_name in cluster["nodes"]:
            return _expand_cluster_config(node_name, cluster)

    raise CommandExecutionError(
        SaltCloudConfigError(
            "Node {0} not declared in pillar opensearch_clusters.".format(node_name)
        )
    )


def _expand_cluster_config(node_name, config):
    config = dict(config)
    nodes = _convert_to_ip(config["nodes"])

    config.update(
        {
            "nodes": nodes,
            "nodes_certificates": _get_nodes_info(config["nodes"]),
            "node_name": node_name,
            "network_host": _get_ip(node_name),
            "lead_nodes": nodes,
            "dashboards_nodes": nodes,
        }
    )

    return config


def _convert_to_ip(node_names):
    return [_get_ip(node_name) for node_name in node_names]


def _get_ip(node_name):
    try:
        network = __pillar__["nodes"][node_name]["network"]
    except KeyError:
        raise CommandExecutionError(
            SaltCloudConfigError(
                "Node {0} not declared in pillar nodes.".format(node_name)
            )
        )

    for field in ["ipv4_address", "ipv6_address"]:
        if field in network:
            return network[field]


def _get_nodes_info(node_names):
    return [_get_node_info(id) for node_name in node_names]


def _get_node_info(node_name):
    return {
        "id": node_name,
        "fqdn": __pillar__["nodes"][node_name]["hostname"],
        "ip": _get_ip(node_name),
    }


def hash_password(clear_password):
    command = (
        "/opt/opensearch/plugins/opensearch-security/tools/hash.sh -p '{0}'".format(
            clear_password
        )
    )
    env = {
        "JAVA_HOME": "/opt/opensearch/jdk",
    }

    return __salt__["cmd.shell"](command, env=env)


def list_certificates(node_name=None):
    config = get_config(node_name)

    certificates = ["admin", "root-ca"]

    for node in config["nodes_certificates"]:
        certificates.extend([node["id"], node["id"] + "_http"])

    return certificates
