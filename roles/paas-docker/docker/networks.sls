#   -------------------------------------------------------------
#   Salt — Provision Docker engine
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2018-09-11
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% set networks = salt['pillar.get']("docker_networks:" + grains['id'], {}) %}

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
