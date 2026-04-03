#   -------------------------------------------------------------
#   Salt — Provision Docker engine
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% set has_selinux = salt['grains.get']('selinux:enabled', False) %}

{% for instance, container in pillar['docker_containers']['docker-registry-api'].items() %}

#   -------------------------------------------------------------
#   Container
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{{ instance }}:
  docker_container.running:
    - detach: True
    - interactive: True
    - image: nasqueron/docker-registry-api
    - binds: /srv/{{ container['registry_instance'] }}:/var/lib/registry
    - ports:
      - 8000
    - port_bindings:
      - {{ container['app_port'] }}:8000

{% endfor %}
