#   -------------------------------------------------------------
#   Salt — Provision Docker engine
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2018-03-10
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

#   -------------------------------------------------------------
#   Monitoring
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

docker_containers_monitoring:

  # Go to URL, check it's an HTTP 200 response
  check_http_200:
    acme_dns: /health
    cachet: /api/v1/ping
    hound: /healthz

    # Test a regular URL for services without health check
    api-datasources: /datasources
    etherpad: /stats
    hauk: /
    jenkins: /login
    registry: /

  # Go to URL, check it's an HTTP 200 response code + "ALIVE" as content
  check_http_200_alive:
    auth-grove: /status
    docker-registry-api: /status
    notifications: /status
    tommy: /status

  # Same than check_http_200, but we need to query the proxy
  check_http_200_proxy:
    openfire: /login.jsp
    pixelfed: /api/nodeinfo/2.0.json

  # Same than check_http_200_alive, but we need to query the proxy
  check_http_200_alive_proxy:
    phabricator: /status

 #   -------------------------------------------------------------
 #   Ports listened by known applications
 #   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

rabbitmq_ports:
  -  4369 # epmd, Erlang peer discovery service used by RabbitMQ and CLI tools
  -  5671 # AMQP with TLS (AMQPS)
  -  5672 # AMQP
  - 15672 # Management UI, HTTP API, rabbitmqadmin (management plugin port)
  - 25672 # Erlang distribution server port - Federation, rabbitmqctl

  # Not implemented ports, as we don't use those protocols:
  #
  # -  1883 # MQTT
  # -  8883 # MQTT with TLS
  # - 15674 # STOMP over a WebSocket connection (rabbitmq_web_stomp plugin port)
  # - 15675 # MQTT  over a WebSocket connection (rabbitmq_web_mqtt plugin port)
  # - 15692 # Prometheus metrics (rabbitmq_prometheus plugin port)
  # - 61613 # STOMP
  # - 61614 # STOMP with TLS
