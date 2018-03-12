#   -------------------------------------------------------------
#   Salt — Provision Docker engine
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2018-03-16
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import dirs with context %}
{% set containers = salt['pillar.get']('docker_containers:' + grains['id'], {}) %}

#   -------------------------------------------------------------
#   includes folder
#
#    :: general configuration
#    :: application-specific code
#   -------------------------------------------------------------

{{ dirs.etc }}/nginx/includes:
  file.recurse:
    - source: salt://roles/paas-docker/nginx/files/includes
    - dir_mode: 755
    - file_mode: 644

#   -------------------------------------------------------------
#   vhosts folder
#   -------------------------------------------------------------

{% for container, args in containers.items() %}

{{ dirs.etc }}/nginx/vhosts/{{ container }}.conf:
  file.managed:
    - source: salt://roles/paas-docker/nginx/files/vhosts/{{ container }}.conf
    - mode: 644
    - template: jinja
    - context:
        fqdn: {{ args['host'] }}
        app_port: {{ args['app_port'] }}

{% endfor %}
