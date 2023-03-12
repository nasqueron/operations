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
  - getsentry/snuba:nightly
  - tianon/exim4
  - yandex/clickhouse-server:20.3.9.70

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
  # ClickHouse
  #
  clickhouse:
    sentry_clickhouse:
      version: 20.3.9.70
      network: sentry
      config: sentry.xml
      max_memory_ratio: 0.2

  #
  # Snuba
  #

  snuba:
    sentry_snuba_api:
      network: sentry
      api: True
      services: &sentry_snuba_services
        broker: sentry_kafka:9092
        clickhouse: sentry_clickhouse
        redis: sentry_redis

    sentry_snuba_consumer:
      command: consumer --storage errors --auto-offset-reset=latest --max-batch-time-ms 750
      network: sentry
      services: *sentry_snuba_services

    sentry_snuba_outcomes_consumer:
      command: consumer --storage outcomes_raw --auto-offset-reset=earliest --max-batch-time-ms 750
      network: sentry
      services: *sentry_snuba_services

    sentry_snuba_replacer:
      command: replacer --storage errors --auto-offset-reset=latest
      network: sentry
      services: *sentry_snuba_services

    sentry_snuba_replays_consumer:
      command: consumer --storage replays --auto-offset-reset=latest --max-batch-time-ms 750
      network: sentry
      services: *sentry_snuba_services

    sentry_snuba_sessions_consumer:
      command: consumer --storage sessions_raw --auto-offset-reset=latest --max-batch-time-ms 750
      network: sentry
      services: *sentry_snuba_services

    sentry_snuba_subscription_consumer_events:
      command: subscriptions-scheduler-executor --dataset events --entity events --auto-offset-reset=latest
        --no-strict-offset-reset --consumer-group=snuba-events-subscriptions-consumers
        --followed-consumer-group=snuba-consumers --delay-seconds=60 --schedule-ttl=60
        --stale-threshold-seconds=900
      network: sentry
      services: *sentry_snuba_services

    sentry_snuba_subscription_consumer_sessions:
      command: subscriptions-scheduler-executor --dataset sessions --entity sessions
        --auto-offset-reset=latest --no-strict-offset-reset --consumer-group=snuba-sessions-subscriptions-consumers
        --followed-consumer-group=sessions-group --delay-seconds=60 --schedule-ttl=60
        --stale-threshold-seconds=900
      network: sentry
      services: *sentry_snuba_services

    sentry_snuba_subscription_consumer_transactions:
      command: subscriptions-scheduler-executor --dataset transactions --entity transactions
        --auto-offset-reset=latest --no-strict-offset-reset --consumer-group=snuba-transactions-subscriptions-consumers
        --followed-consumer-group=transactions_group --delay-seconds=60 --schedule-ttl=60
        --stale-threshold-seconds=900
      network: sentry
      services: *sentry_snuba_services

    sentry_snuba_transactions_consumer:
      command: consumer --storage transactions --consumer-group transactions_group
        --auto-offset-reset=latest --max-batch-time-ms 750
      network: sentry
      services: *sentry_snuba_services

  #
  # Sentry
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
