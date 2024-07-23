#   -------------------------------------------------------------
#   Salt — Monitoring
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import dirs, packages, services with context %}
{% from "roles/core/monitoring/map.jinja" import monitoring_services with context %}

{% set network = salt["node.resolve_network"]() %}

#   -------------------------------------------------------------
#   Software
#
#   :: prometheus-node-exporter for kernel and hardware metrics
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

monitoring_prometheus_software:
  pkg.installed:
    - pkgs:
      - {{ packages["prometheus-node-exporter"] }}

#   -------------------------------------------------------------
#   Services
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% if services["manager"] == "rc" %}
    {% set source = "rc/prometheus-node-exporter.conf" %}
    {% set target = "/etc/rc.conf.d/" + monitoring_services["prometheus-node-exporter"] %}
{% elif services["manager"] == "systemd" %}
    {% set source = "prometheus-node-exporter.env" %}
    {% set target = "/etc/default/prometheus-node-exporter" %}
{% endif %}

prometheus_node_exporter_service_config:
  file.managed:
    - name: {{ target }}
    - source: salt://roles/core/monitoring/files/{{ source }}
    - template: jinja
    - context:
        ip: {{ network.private_ipv4_address }}

prometheus_node_exporter_running:
  service.running:
    - name: {{ monitoring_services["prometheus-node-exporter"] }}
