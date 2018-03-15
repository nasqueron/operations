#   -------------------------------------------------------------
#   Salt — Provision Docker engine
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2018-03-11
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% set containers = salt['pillar.get']('docker_containers:' + grains['id'], []) %}

include:
{% for container in containers %}
  - .{{ container }}
{% endfor %}
