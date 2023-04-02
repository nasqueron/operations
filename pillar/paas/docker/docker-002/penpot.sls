#   -------------------------------------------------------------
#   Salt — Provision Docker engine
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   Service:        Penpot
#   Note:           If compared with upstream installation method,
#                   the frontend part is skipped. This is to avoid
#                   PaaS nginx -> frontend nginx -> backend server.
#                   Frontend content is directly served by our nginx.
#   -------------------------------------------------------------

docker_networks:
  penpot:
    subnet: 172.21.2.0/24

docker_images:
  - penpotapp/backend
  - penpotapp/exporter

docker_containers:

  #
  # Core services used by Penpot
  #

  exim:
    penpot_smtp:
      mailname: mx.design.nasqueron.org
      network: penpot

  postgresql:
    penpot_db:
      network: penpot
      version: 15
      credential: nasqueron/penpot/postgresql
      db: penpot
      initdb_args: --data-checksums

  redis:
    penpot_redis:
      network: penpot
      version: 7

  #
  # Penpot applications
  #

  penpot_web:
    penpot_web:
      realm: penpot
      network: penpot
      host: design.nasqueron.org
      app_port: 17080
      db:
        uri: postgresql://penpot_db/penpot
      services:
        postgresql: penpot_db
        redis: penpot_redis
        smtp: penpot_smtp
        exporter: http://localhost:17300
      credentials:
        github: nasqueron/penpot/github
        postgresql: nasqueron/penpot/postgresql
        secret_key: nasqueron/penpot/secret_key
      features: &features
        # Features relevant for both frontend and backend
        - registration
        - login-with-password
        - login-with-github
        - secure-session-cookies
        - webhooks

        # Features specific to the backend
        - prepl-server
        - smtp

  penpot_exporter:
    penpot_exporter:
      realm: penpot
      network: penpot
      app_port: 17300
      services:
        frontend: https://design.nasqueron.org
        redis: penpot_redis
