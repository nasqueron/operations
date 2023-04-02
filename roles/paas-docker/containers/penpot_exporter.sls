#   -------------------------------------------------------------
#   Salt — Provision Penpot
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% set containers = pillar["docker_containers"] %}

{% for instance, container in containers["penpot_exporter"].items() %}

#   -------------------------------------------------------------
#   Container
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{{ instance }}:
  docker_container.running:
    - detach: True
    - interactive: True
    - image: penpotapp/exporter
    - networks:
      - {{ container["network"] }}
    - binds: /srv/{{ container["realm"] }}/assets:/opt/data/assets
    - environment:
        - PENPOT_PUBLIC_URI: {{ container["services"]["frontend"] }}
        - PENPOT_REDIS_URI: redis://{{ container["services"]["redis"] }}/0
    - ports:
        - 80
    - port_bindings:
        - {{ container['app_port'] }}:80

{% endfor %}
