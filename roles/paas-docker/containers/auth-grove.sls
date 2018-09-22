#   -------------------------------------------------------------
#   Salt — Provision Docker engine
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2016-05-21
#   License:        Trivial work, not eligible to copyright
#   Description:    SSO for Nasqueron services.
#   Image:          nasqueron/auth-grove
#   Services used:  MySQL server    (acquisitariat)
#                   Docker volume   (/data/login/storage)
#   -------------------------------------------------------------

{% set has_selinux = salt['grains.get']('selinux:enabled', False) %}
{% set containers = pillar['docker_containers'][grains['id']] %}

{% for instance, container in containers['auth-grove'].items() %}

#   -------------------------------------------------------------
#   Data directory
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/srv/{{ instance }}/storage:
  file.directory:
    - user: 431
    - group: 433
    - makedirs: True

{% if has_selinux %}
selinux_context_{{ instance }}_data:
  selinux.fcontext_policy_present:
    - name: /srv/{{ instance }}/storage
    - sel_type: container_file_t

selinux_context_{{ instance }}_data_applied:
  selinux.fcontext_policy_applied:
    - name: /srv/{{ instance }}/storage
{% endif %}

#   -------------------------------------------------------------
#   Container
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{{ instance }}:
  docker_container.running:
    - detach: True
    - interactive: True
    - image: nasqueron/auth-grove
    - links: {{ container['mysql_link'] }}:mysql
    - environment:
        - DB_DRIVER: mysql
        - DB_HOST: mysql
        - DB_PORT: 3306
        - DB_DATABASE: {{ instance }}
        - DB_USERNAME: {{ salt['zr.get_username'](container['credential']) }}
        - DB_PASSWORD: {{ salt['zr.get_password'](container['credential']) }}

        - CANONICAL_URL: https://{{ container['host'] }}
        - TRUST_ALL_PROXIES: 1
    - binds: /srv/{{ instance }}/storage:/var/wwwroot/default/storage
    - ports:
      - 80
    - port_bindings:
      - 127.0.0.1:{{ container['app_port'] }}:80

{% endfor %}
