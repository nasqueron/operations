#   -------------------------------------------------------------
#   Salt configuration for Nasqueron servers
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   Description:    Table of the services to use in configuration
#   -------------------------------------------------------------

nasqueron_services:
  # Complector services
  salt_primary: 172.27.27.7
  salt_api_url: https://172.27.27.7:8300

  vault: 172.27.27.7
  vault_url: https://172.27.27.7:8200

  # PaaS Docker
  docker:
    api: 172.27.27.5
    cd: 172.27.27.5
    notifications: 172.27.27.5
    all:
      - 172.27.27.4
      - 172.27.27.5

  # Alkane
  alkane:
    - 172.27.27.3 # hervil for webmail clients
    - 172.27.27.10 # web-001
    - 172.27.27.35 # windriver

  # Databases
  db-A: 172.27.27.8
  db-B: 172.27.27.9

  # Mail
  mail:
    dovecot:
      exporter: 172.27.27.3
    postfix:
      exporter: 172.27.27.3

  # NetBox
  netbox_domain: netbox.nasqueron.org

  # RabbitMQ
  rabbitmq:
    white-rabbit: 172.27.27.5

  # Observability
  prometheus: 172.27.27.35

  devservers:
    - 172.27.27.35 # windriver

  all:
    - 172.27.27.1 # router-001
    - 172.27.27.3 # hervil
    - 172.27.27.4 # dwellers
    - 172.27.27.5 # docker-002
    - 172.27.27.7 # complector
    - 172.27.27.8 # db-A-001
    - 172.27.27.9 # db-B-001
    - 172.27.27.10 # web-001
    - 172.27.27.35 # windriver
