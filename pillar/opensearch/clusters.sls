#
# Currently, declare OpenSearch clusters as single-node, per machine.
#

opensearch_clusters:

  #
  # Infrastructure: logs and metrics
  #

  infra_logs:
    cluster_name: infra-logs
    cluster_type: single-node
    nodes:
      - cloudhugger
    users:
      admin: nasqueron/opensearch/infra-logs/internal_users/admin
      dashboards: nasqueron/opensearch/infra-logs/internal_users/dashboards
    heap_size: 26G
