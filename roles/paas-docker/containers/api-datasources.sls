#   -------------------------------------------------------------
#   Salt — Provision Docker engine
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2020-06-02
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% set containers = pillar['docker_containers'][grains['id']] %}

{% for instance, container in containers['api-datasources'].items() %}

#   -------------------------------------------------------------
#   Container
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{{ instance }}:
  docker_container.running:
    - detach: True
    - interactive: True
    - image: nasqueron/api-datasources
    - env:
      - API_ENTRY_POINT: {{ container['api_entry_point'] }}
    - ports:
      - 80
    - port_bindings:
      - {{ container['app_port'] }}:80

{% endfor %}
