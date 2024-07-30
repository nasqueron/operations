#   -------------------------------------------------------------
#   Salt configuration for Nasqueron servers
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   Description:    Prometheus configuraiton
#   -------------------------------------------------------------

#   -------------------------------------------------------------
#   Scrape jobs
#
#   Options supported from Prometheus scrape_config syntax:
#       - name
#       - scheme
#       - metrics_path
#
#   Options mapped with pillar/services/table.sls for services:
#       - services_targets: list of services dictionaries
#         - service: name in nasqueron_services pillar
#         - port
#
#       - services_targets_list will have the same behavior
#         but will read a list of services in nasqueron_services
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

prometheus_scrape_jobs:
  prometheus_itself:
    name: prometheus
    services_targets:
      - service: prometheus
        port: 9090

  node_exporter:
   name: node
   services_targets_list:
      - service: "all"
        port: 9100

  netbox:
    name: netbox
    scheme: https
    services_targets:
      - service: netbox_domain
        port: 443

  paas_docker:
    name: docker
    services_targets_list:
      - service: "docker:all"
        port: 9323

  postfix:
    name: postfix
    services_targets:
      - service: "mail:postfix:exporter"
        port: 9154

  rabbitmq:
    name: rabbitmq
    services_targets:
      - service: "rabbitmq:white-rabbit"
        port: 15692
