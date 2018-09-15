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
    - image: cachethq/docker:latest
    - links: {{ container['mysql_link'] }}:mysql
    - environment:
        - DB_DRIVER: mysql
        - DB_HOST: mysql
        - DB_PORT: 3306
        - DB_DATABASE: cachet
        - DB_USERNAME: {{ salt['zr.get_username'](container['credential']) }}
        - DB_PASSWORD: {{ salt['zr.get_password'](container['credential']) }}
        - DB_PREFIX: ""

        - APP_KEY: {{ salt['zr.get_token'](container['app_key']) }}
        - APP_LOG: errorlog
        - APP_DEBUG: "false"
    - ports:
      - 8000
    - port_bindings:
      - {{ container['app_port'] }}:8000

{% endfor %}
