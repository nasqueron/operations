#   -------------------------------------------------------------
#   Salt — Provision Docker engine
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2016-12-15
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% set containers = pillar['docker_containers'][grains['id']] %}

{% for instance, container in containers['cachet'].items() %}

#   -------------------------------------------------------------
#   Container
#
#   Image:          dereckson/cachet
#   Description:    PHP application to offer server status
#                   information
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{{ instance }}:
  docker_container.running:
    - detach: True
    - interactive: True
    - image: dereckson/cachet
    - links: {{ container['mysql_link'] }}:mysql
    - environment:
        - DB_HOST: mysql
        - DB_DATABASE: cachet
        - DB_USERNAME: {{ salt['zr.get_username'](container['credential']) }}
        - DB_PASSWORD: {{ salt['zr.get_password'](container['credential']) }}
    - ports:
      - 80
    - port_bindings:
      - {{ container['app_port'] }}:80

{% endfor %}
