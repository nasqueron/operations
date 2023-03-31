#   -------------------------------------------------------------
#   Salt — Provision Docker engine
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2016-01-23
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% set has_selinux = salt['grains.get']('selinux:enabled', False) %}

{% for instance, container in pillar['docker_containers']['notifications'].items() %}

  #   -------------------------------------------------------------
  #   Storage directory
  #   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/srv/{{ instance }}/storage:
  file.directory:
    - user: 431
    - group: 433
    - makedirs: True

/srv/{{ instance }}/storage/app/credentials.json:
  file.managed:
    - user: 431
    - group: 433
    - mode: 400
    - makedirs: True
    - show_changes: False
    - contents: |
        {{ salt['notifications.get_credentials']() | json }}

/srv/{{ instance }}/storage/app/DockerHubTriggers.json:
  file.managed:
    - user: 431
    - group: 433
    - mode: 400
    - show_changes: False
    - contents: |
        {{ salt['notifications.get_dockerhub_triggers']() | json }}

{% for folder, configs in salt['pillar.get']("notifications_configuration", {}).items() %}
{% for config_file, config in configs.items() %}
/srv/{{ instance }}/storage/app/{{ folder }}/{{ config_file }}.json:
  file.managed:
    - user: 431
    - group: 433
    - makedirs: True
    - contents: |
        {{ config | json }}
{% endfor %}
{% endfor %}

{% if has_selinux %}
selinux_context_notifications_data_{{ instance }}:
  selinux.fcontext_policy_present:
    - name: /srv/{{ instance }}/storage
    - sel_type: container_file_t

selinux_context_notifications_data_applied_{{ instance }}:
  selinux.fcontext_policy_applied:
    - name: /srv/{{ instance }}/storage
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
        - BROKER_USERNAME: {{ salt['credentials.get_username'](container['credentials']['broker']) }}
        - BROKER_PASSWORD: {{ salt['credentials.get_password'](container['credentials']['broker']) }}
        - BROKER_VHOST: dev

        - MAILGUN_DOMAIN: {{ salt['credentials.get_username'](container['credentials']['mailgun']) }}
        - MAILGUN_APIKEY: {{ salt['credentials.get_password'](container['credentials']['mailgun']) }}

        - SENTRY_DSN: {{ salt['credentials.get_sentry_dsn'](container["sentry"]) }}
        - SENTRY_TRACES_SAMPLE_RATE: 1.0
    - ports:
        - 80
    - port_bindings:
        - {{ container['app_port'] }}:80

{% endfor %}
