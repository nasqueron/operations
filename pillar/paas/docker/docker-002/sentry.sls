#   -------------------------------------------------------------
#   Salt — Provision Docker engine
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   Service:        Sentry
#   -------------------------------------------------------------

docker_networks:
  sentry:
    subnet: 172.18.3.0/24

docker_images:
  - library/postgres
  - library/redis:3.2-alpine
  - library/sentry
  - tianon/exim4

docker_containers:

  #
  # Core services used by Sentry
  #

  exim:
    sentry_smtp:
      mailname: mx.sentry.nasqueron.org
      network: sentry

  memcached:
    sentry_memcached:
      version: 1.6.9-alpine
      network: sentry

  redis:
    sentry_redis:
      network: sentry

  postgresql:
    sentry_db:
      credential: nasqueron.sentry.postgresql

  #
  # Kafka instance
  #

  zookeeper:
    sentry_zookeeper:
      version: 5.5.0
      network: sentry

  kafka:
    sentry_kafka:
      version: 5.5.0
      zookeeper: sentry_zookeeper
      network: sentry
      topics:
        - ingest-attachments
        - ingest-transactions
        - ingest-events
        - ingest-replay-recordings

  #
  # Services maintained by Sentry
  #

  sentry:
    sentry_web_1:
      app_port: 26080
      host: sentry.nasqueron.org

      # As an instance is divided between a web, a cron and a worker
      # containers, we need an identified to share a data volume.
      realm: nasqueron
      network: sentry

  sentry_worker:
    sentry_worker_1:
      realm: nasqueron
      network: sentry

  sentry_cron:
    sentry_cron:
      realm: nasqueron
      network: sentry

#   -------------------------------------------------------------
#   Services configuration
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

kakfa_loggers:
  kafka.cluster: WARN
  kafka.controller: WARN
  kafka.coordinator: WARN
  kafka.log: WARN
  kafka.server: WARN
  kafka.zookeeper: WARN
  state.change.logger: WARN
