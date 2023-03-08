#   -------------------------------------------------------------
#   Salt — Provision Docker engine
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2018-03-11
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% set services = pillar.get('docker_containers', {}) %}

{% if services %}

include:
{% for service in services %}
  - .{{ service }}
{% endfor %}

{% endif %}
