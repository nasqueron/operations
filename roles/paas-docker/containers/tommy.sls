#   -------------------------------------------------------------
#   Salt — Provision Docker engine
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2018-09-20
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% set containers = pillar['docker_containers'][grains['id']] %}

{% for instance, container in containers['tommy'].items() %}

#   -------------------------------------------------------------
#   Container
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{{ instance }}:
  docker_container.running:
    - detach: True
    - interactive: True
    - image: nasqueron/tommy
    - environment:
        - HUDSON_URL: {{ container['jenkins_url'] }}
    - ports:
      - 4567
    - port_bindings:
      - {{ container['app_port'] }}:4567 # HTTP

{% endfor %}
