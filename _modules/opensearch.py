# -*- coding: utf-8 -*-

#   -------------------------------------------------------------
#   Salt — PaaS OpenSearch execution module
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Description:    Functions related to OpenSearch configuration
#   License:        BSD-2-Clause
#   -------------------------------------------------------------


from salt.exceptions import CommandExecutionError, SaltCloudConfigError


def get_config(nodename=None):
    """
    A function to get relevant values for OpenSearch configuration.

    CLI Example:

        salt * opensearch.get_config
    """
    if nodename is None:
        nodename = __grains__['id']

    try:
        clusters = __pillar__['opensearch_clusters']
    except KeyError:
        clusters = []

    for _, cluster in clusters.items():
        if nodename in cluster['nodes']:
            return _expand_cluster_config(nodename, cluster)

    raise CommandExecutionError(
        SaltCloudConfigError(
            "Node {0} not declared in pillar opensearch_clusters.".format(nodename)
        )
    )


def _expand_cluster_config(nodename, config):
    config = dict(config)
    nodes = _convert_to_ip(config["nodes"])

    config.update({
        "nodes": nodes,
        "nodes_certificates": _get_nodes_info(config["nodes"]),
        "node_name": nodename,
        "network_host": _get_ip(nodename),
        "lead_nodes": nodes,
    })

    return config


def _convert_to_ip(ids):
    return [_get_ip(id) for id in ids]


def _get_ip(nodename):
    try:
        network = __pillar__['nodes'][nodename]['network']
    except KeyError:
        raise CommandExecutionError(
            SaltCloudConfigError(
                "Node {0} not declared in pillar nodes.".format(nodename)
            )
        )

    for field in ['ipv4_address', 'ipv6_address']:
        if field in network:
            return network[field]


def _get_nodes_info(ids):
    return [_get_node_info(id) for id in ids]


def _get_node_info(nodename):
    return {
        "id": nodename,
        "fqdn": __pillar__['nodes'][nodename]['hostname'],
        "ip": _get_ip(nodename),
    }


def hash_password(clear_password):
    command = "/opt/opensearch/plugins/opensearch-security/tools/hash.sh -p '{0}'".format(clear_password)
    env = {
        "JAVA_HOME": "/opt/opensearch/jdk",
    }

    return __salt__['cmd.shell'](command, env=env)


def list_certificates(nodename=None):
    config = get_config(nodename=None)

    certificates = ['admin', 'root-ca']

    for node in config["nodes_certificates"]:
        certificates.extend([node['id'], node['id'] + '_http'])

    return certificates
