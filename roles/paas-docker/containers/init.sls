#   -------------------------------------------------------------
#   Salt — Provision Docker engine
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2018-03-11
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% set containers = salt['node.filter_by_name']('docker_containers') %}

include:
{% for container in containers %}
  - .{{ container }}
{% endfor %}
