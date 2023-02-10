#   -------------------------------------------------------------
#   Salt — RabbitMQ
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

#   -------------------------------------------------------------
#   RabbitMQ clusters
#
#   Each cluster is defined by a deployment method (e.g. docker),
#   and the node we can use to configure it.
#
#   The cluster configuration is a collection of vhosts and users:
#
#   vhosts:
#     <vhost name>: <configuration>
#
#   users:
#     <user>: <password FULL secret path in Vault>
#
#     In addition, a root account is managed by deployment states.
#
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#
#   The vhost configuration allows to define the exchanges and queues,
#   and the permissions users have on them.
#
#   exchanges:
#     type is 'direct', 'topic' or 'fanout'
#
#   queues:
#     Application can create their own ephemeral queue.
#     For that, it needs configure permission on the vhost.
#
#     If an application needs a stable one, it should be configured here,
#     so we can drop the configure permission.
#
#   permissions:
#     See https://www.rabbitmq.com/access-control.html#authorisation
#     for the needed permissions for an AMQP operation
#
#     To give access to server-generated queue names, use amq\.gen.*
#     To not give any access, use blank string
#
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

rabbitmq_clusters:
  white-rabbit:
    deployment: docker
    node: docker-002
    container: white-rabbit
    url: https://white-rabbit.nasqueron.org/

    vhosts:

      ###
      ### Nasqueron dev services:
      ###   - Notifications center
      ###

      dev: &nasqueron-dev-services-vhost
        description: Nasqueron dev services

        exchanges:
          # Producer: Notifications center
          # Consumers: any notifications client
          notifications:
            type: topic
            durable: True

        queues:
          # Used by Wearg to stream notifications to IRC
          wearg-notifications:
            durable: True

        bindings:
          - exchange: notifications
            queue: wearg-notifications
            routing_key: '#'

        permissions:
          # Notifications center (paas-docker role / notifications container)
          notifications:
            configure: '.*'
            read:      '.*'
            write:     '.*'

          # Wearg (viperserv role)
          wearg:
            configure: '^$'
            read:      '^wearg\-notifications$'
            write:     '^$'

          # Notifications CLI clients
          notifications-ysul: &notifications-client-permissions
            configure: '^(amq\.gen.*|notifications)$'
            read:      '^(amq\.gen.*|notifications)$'
            write:     '^(amq\.gen.*|notifications)$'
          notifications-windriver: *notifications-client-permissions

    users:
      # Notifications center server and clients
      notifications: ops/secrets/nasqueron.notifications.broker
      wearg: apps/viperserv/broker
      notifications-ysul: ops/secrets/nasqueron/notifications/notifications-cli/ysul
      notifications-windriver: ops/secrets/nasqueron/notifications/notifications-cli/windriver
