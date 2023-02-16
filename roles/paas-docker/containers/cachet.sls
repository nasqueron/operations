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
    - image: nasqueron/cachet:latest
    - links: {{ container['mysql_link'] }}:mysql
    - environment:
        - DB_DRIVER: mysql
        - DB_HOST: mysql
        - DB_PORT: 3306
        - DB_DATABASE: cachet
        - DB_USERNAME: {{ salt['credentials.get_username'](container['credential']) }}
        - DB_PASSWORD: {{ salt['credentials.get_password'](container['credential']) }}

        - APP_KEY: {{ salt['credentials.get_token'](container['app_key']) }}
        - APP_LOG: errorlog
        - APP_DEBUG: "false"
    - ports:
      - 8000
    - port_bindings:
      - {{ container['app_port'] }}:80

{% endfor %}
