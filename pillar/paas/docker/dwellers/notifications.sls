#   -------------------------------------------------------------
#   Salt — Provision Docker engine
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   Service:        Sentry
#   -------------------------------------------------------------

docker_aliases:
  - &ipv4_dwellers_restricted 172.27.27.4

docker_images:
  - nasqueron/notifications
  - nasqueron/rabbitmq
  - nasqueron/vault

docker_networks:
  notifications-int:
    subnet: 172.21.6.0/24

docker_containers:

  rabbitmq:
    orange-rabbit:
      ip: *ipv4_dwellers_restricted
      host: orange-rabbit.integration.nasqueron.org
      app_port: 15672
      network: notifications-int
      credentials:
        erlang_cookie: nasqueron/rabbitmq/orange-rabbit/erlang-cookie
        root: nasqueron/rabbitmq/orange-rabbit/root

  vault:
    vault-notifications:
      ip: *ipv4_dwellers_restricted
      host: vault-notifications.integration.nasqueron.org
      app_port: 48080
      network: notifications-int

  notifications:
    notifications:
      host: notifications.integration.nasqueron.org
      app_port: 37080
      network: notifications-int
      broker: orange_rabbit
      credentials:
        broker: nasqueron/rabbitmq/orange-rabbit/notifications
      sentry:
        realm: nasqueron
        project_id: 2
        credential: nasqueron.notifications.sentry
        environment: integration
