#   -------------------------------------------------------------
#   Salt — Provision Docker engine
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2018-03-11
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% set services = salt['node.filter_by_name']('docker_containers') %}

{% if services %}

include:
{% for service in services %}
  - .{{ service }}
{% endfor %}

{% endif %}
