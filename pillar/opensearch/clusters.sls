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

    heap_size: 26G

    users:
      admin: nasqueron.opensearch.infra-logs.internal_users.admin
      dashboards: nasqueron.opensearch.infra-logs.internal_users.dashboards
      beat_docker: nasqueron.opensearch.infra-logs.internal_users.beat_docker
    ingest_clients_users:
      - beat_docker

    index_management:
      index_policies:
        - prune_old_indices
