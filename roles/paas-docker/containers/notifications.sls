#   -------------------------------------------------------------
#   Salt — Provision Docker engine
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2016-01-23
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% set has_selinux = salt['grains.get']('selinux:enabled', False) %}
{% set containers = pillar['docker_containers'][grains['id']] %}

{% for instance, container in containers['notifications'].items() %}

  #   -------------------------------------------------------------
  #   Storage directory
  #   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/srv/{{ instance }}/storage:
  file.directory:
    - user: 999
    - group: 999
    - makedirs: True

/srv/{{ instance }}/storage/app/credentials.json:
  file.managed:
    - user: 999
    - group: 999
    - makedirs: True
    - contents: |
        {{ pillar['notifications_credentials'] | json }}

{% for folder, configs in salt['pillar.get']("notifications_configuration", {}).items() %}
{% for config_file, config in configs.items() %}
/srv/{{ instance }}/storage/app/{{ folder }}/{{ config_file }}.json:
  file.managed:
    - user: 999
    - group: 999
    - makedirs: True
    - contents: |
        {{ config | json }}
{% endfor %}
{% endfor %}

{% if has_selinux %}
selinux_context_rabbitmq_data_{{ instance }}:
  selinux.fcontext_policy_present:
    - name: /srv/rabbitmq/{{ instance }}/lib
    - sel_type: container_file_t

selinux_context_rabbitmq_data_applied_{{ instance }}:
  selinux.fcontext_policy_applied:
    - name: /srv/rabbitmq/{{ instance }}/lib
{% endif %}

#   -------------------------------------------------------------
#   Container
#
#   Image:          nasqueron/notifications
#   Description:    Listen to webhooks, fire notifications to
#                   the broker. Used for CI / IRC notifications.
#   Services used:  RabbitMQ broker (white-rabbit)
#                   Docker volume   (/srv/notifications/storage)
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{{ instance }}:
  docker_container.running:
    - detach: True
    - interactive: True
    - image: nasqueron/notifications
    - binds: /srv/{{ instance }}/storage:/var/wwwroot/default/storage
    - links:
        - {{ container['broker_link'] }}:mq
    - environment:
        - BROKER_HOST: mq
        - BROKER_USERNAME: {{ salt['zr.get_username'](container['credentials']['broker']) }}
        - BROKER_PASSWORD: {{ salt['zr.get_password'](container['credentials']['broker']) }}
        - BROKER_VHOST: dev

        - MAILGUN_DOMAIN: {{ salt['zr.get_username'](container['credentials']['mailgun']) }}
        - MAILGUN_APIKEY: {{ salt['zr.get_password'](container['credentials']['mailgun']) }}

        - SENTRY_DSN: {{ salt['zr.get_sentry_dsn'](container['sentry']) }}
    - ports:
        - 80
    - port_bindings:
        - {{ container['app_port'] }}:80

{% endfor %}
