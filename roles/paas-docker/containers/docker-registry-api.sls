#   -------------------------------------------------------------
#   Salt — Provision Docker engine
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2018-09-18
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% set has_selinux = salt['grains.get']('selinux:enabled', False) %}
{% set containers = pillar['docker_containers'][grains['id']] %}

{% for instance, container in containers['docker-registry-api'].items() %}

#   -------------------------------------------------------------
#   Container
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{{ instance }}:
  docker_container.running:
    - detach: True
    - interactive: True
    - image: nasqueron/docker-registry-api
    - binds: /srv/{{ container['registry_instance'] }}:/var/lib/registry
    - environment:
        - API_ENTRY_POINT: {{ container['api_entry_point'] }}
    - ports:
      - 8000
    - port_bindings:
      - {{ container['app_port'] }}:8000

{% endfor %}
