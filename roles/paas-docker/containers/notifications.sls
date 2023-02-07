#   -------------------------------------------------------------
#   Salt — Provision Docker engine
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2016-01-23
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% set containers = pillar['docker_containers'][grains['id']] %}

{% for instance, container in containers['notifications'].items() %}

#   -------------------------------------------------------------
#   Container
#
#   Image:          nasqueron/notifications
#   Description:    Listen to webhooks, fire notifications to
#                   the broker. Used for CI / IRC notifications.
#   Services used:  RabbitMQ broker (white-rabbit)
#                   Docker volume   (/data/notifications/storage)
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{{ instance }}:
  docker_container.running:
    - detach: True
    - interactive: True
    - image: nasqueron/notifications
    - binds: /srv/notifications/storage:/var/wwwroot/default/storage
    - links:
        - {{ container['broker_link'] }}:mq
    - environment:
        - BROKER_HOST: mq
        - BROKER_USERNAME: {{ salt['credentials.get_username'](container['credentials']['broker']) }}
        - BROKER_PASSWORD: {{ salt['credentials.get_password'](container['credentials']['broker']) }}
        - BROKER_VHOST: dev

        - MAILGUN_DOMAIN: {{ salt['credentials.get_username'](container['credentials']['mailgun']) }}
        - MAILGUN_APIKEY: {{ salt['credentials.get_password'](container['credentials']['mailgun']) }}
    - ports:
        - 80
    - port_bindings:
        - {{ container['app_port'] }}:80

{% endfor %}
