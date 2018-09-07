#   -------------------------------------------------------------
#   Salt — Provision Docker engine
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2016-12-15
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% set containers = pillar['docker_containers'][grains['id']] %}
{% set container = containers['cachet'] %}

{% set db_username = salt['cmd.run']('zr getcredentials 47 username') %}
{% set db_password = salt['cmd.run']('zr getcredentials 47') %}

#   -------------------------------------------------------------
#   Container
#
#   Image:          dereckson/cachet
#   Description:    PHP application to offer server status
#                   information
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

cachet:
  docker_container.running:
    - detach: True
    - interactive: True
    - image: dereckson/cachet
    - links: {{ container['mysql_link'] }}:mysql
    - environment:
        - DB_HOST: mysql
        - DB_DATABASE: cachet
        - DB_USERNAME: {{ db_username }}
        - DB_PASSWORD: {{ db_password }}
    - ports:
      - 80
    - port_bindings:
      - {{ container['app_port'] }}:80
