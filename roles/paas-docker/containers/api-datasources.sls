#   -------------------------------------------------------------
#   Salt — Provision Docker engine
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% for instance, container in pillar['docker_containers']['api-datasources'].items() %}

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
