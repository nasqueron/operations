#   -------------------------------------------------------------
#   Salt — Provision Docker engine
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% set networks = pillar.get("docker_networks", {}) %}

#   -------------------------------------------------------------
#   Bridge networks
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% for network, args in networks.items() %}

docker_network_{{ network }}:
  docker_network.present:
    - name: {{ network }}
    - driver: bridge
    - subnet: {{ args['subnet'] }}

{% endfor %}
