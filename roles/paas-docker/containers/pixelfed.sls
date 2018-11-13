#   -------------------------------------------------------------
#   Salt — Provision Docker engine
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2018-11-12
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% set has_selinux = salt['grains.get']('selinux:enabled', False) %}
{% set containers = pillar['docker_containers'][grains['id']] %}

{% for instance, container in containers['pixelfed'].items() %}

#   -------------------------------------------------------------
#   Data directory
#
#   The uid/gid pair depends of the image base:
#
#     - library/php + fpm: 82:85
#     - library/php + Apache: 33:33
#     - nasqueron/nginx-php7-fpm: 431:433
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
#   Web container
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{{ instance }}:
  docker_container.running:
    - detach: True
    - interactive: True
    - image: nasqueron/pixelfed
    - links:
        - {{ container['links']['redis'] }}:redis
        - {{ container['links']['mysql'] }}:mysql
    - environment:
        - DB_DRIVER: mysql
        - DB_HOST: mysql
        - DB_PORT: 3306
        - DB_DATABASE: {{ instance }}
        - DB_USERNAME: {{ salt['zr.get_username'](container['credentials']['mysql']) }}
        - DB_PASSWORD: {{ salt['zr.get_password'](container['credentials']['mysql']) }}

        # Port must be defined, as Docker link populates REDIS_PORT to tcp://...:6379
        # That gives the following rather strange connection string:
        # tcp://redis:tcp://172.17.0.29:6379
        - REDIS_HOST: redis
        - REDIS_PORT: 6379

        - APP_DOMAIN: {{ container['host'] }}
        - APP_KEY: {{ salt['zr.get_token'](container['credentials']['app_key']) }}
        - APP_NAME: {{ container['app']['title'] }}
        - APP_URL: https://{{ container['host'] }}

        - BROADCAST_DRIVER: redis
        - CACHE_DRIVER: redis
        - QUEUE_DRIVER: redis

        - LOG_CHANNEL: 'daily'

        - MAIL_DRIVER: smtp
        - MAIL_HOST: smtp.eu.mailgun.org
        - MAIL_PORT: 587
        - MAIL_USERNAME: {{ salt['zr.get_username'](container['credentials']['mailgun']) }}
        - MAIL_PASSWORD: {{ salt['zr.get_password'](container['credentials']['mailgun']) }}
        - MAIL_FROM_ADDRESS: no-reply@{{ container['host'] }}
        - MAIL_FROM_NAME: {{ container['app']['title'] }}

        - SESSION_DRIVER: redis
        - SESSION_DOMAIN: {{ container['host'] }}
        - SESSION_SECURE_COOKIE: true

        - TRUST_PROXIES: '*'
        - HTTPS: 1

        - MAX_ALBUM_LENGTH: {{ container['app']['max_album_length'] }}
    - binds: /srv/{{ instance }}/storage:/var/wwwroot/default/storage
    - ports:
        - 80
    - port_bindings:
        - {{ container['app_port'] }}:80

{% endfor %}
