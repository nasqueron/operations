#   -------------------------------------------------------------
#   Salt — Provision Docker engine
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

docker_aliases:
  - &ipv4_docker002 51.255.124.9
  - &ipv4_docker002_restricted 172.27.27.5

#   -------------------------------------------------------------
#   Images
#
#   You can append a :tag (by default, latest is used).
#
#   It's not possible to specify Docker library images only by final name.
#   See https://docs.saltstack.com/en/latest/ref/states/all/salt.states.docker_image.html
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

docker_images:
  - certbot/certbot

  # Core services
  - library/postgres
  - library/redis:3.2-alpine
  - library/registry
  - nasqueron/mysql
  - nasqueron/mysql:5.7
  - nasqueron/rabbitmq

  # ACME DNS server
  - joohoi/acme-dns

  # Nasqueron services
  - nasqueron/auth-grove

  # Nasqueron API microservices
  - nasqueron/docker-registry-api
  - nasqueron/api-datasources

  # Infrastructure and development services
  - nasqueron/aphlict
  - nasqueron/cachet
  - nasqueron/etherpad:production
  - nasqueron/notifications
  - nasqueron/phabricator
  - ghcr.io/hound-search/hound

  # Pixelfed
  - nasqueron/pixelfed

  # Hauk
  - bilde2910/hauk

#   -------------------------------------------------------------
#   Docker engine configuration
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

docker_daemon:
  data-root: /srv/docker

#   -------------------------------------------------------------
#   Containers
#
#   The docker_containers entry allow to declare containers
#   by service. Generally a service matches an image.
#
#   The hierarchy is so as following.
#
#   docker_containers:
#     service codename:
#       instance name:
#          container properties
#
#   The service codename must match a state file in
#   the roles/paas-docker/containers/ directory.
#
#   The container will be run with the specified instance name.
#
#   **nginx**
#
#   The container properties can also describe the information
#   needed to configure nginx with the host and app_port key.
#
#   In such case, a matching vhost file should be declared as
#   roles/paas-docker/nginx/files/vhosts/<service codename>.sls
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

docker_containers:

  #
  # Core services
  #

  mysql:
    acquisitariat:
      credentials:
        root: nasqueron.acquisitariat.mysql
    phpbb_db:
      credentials:
        root: espacewin.phpbb.mysql_root

  redis:
    pixelfed_redis: {}

  registry:
    registry:
      host: registry.nasqueron.org
      app_port: 5000
      allowed_ips:
        # Localhost
        - 127.0.0.1

        # Dwellers
        - 172.27.27.4

        # docker-002
        - 172.27.27.5

  rabbitmq:
    white-rabbit:
      ip: *ipv4_docker002_restricted
      host: white-rabbit.nasqueron.org
      app_port: 15672
      credentials:
        erlang_cookie: nasqueron/rabbitmq/white-rabbit/erlang-cookie
        root: nasqueron/rabbitmq/white-rabbit/root

  #
  # Phabricator
  #

  phabricator:
    # Nasqueron instance
    devcentral:
      app_port: 31080
      host: devcentral.nasqueron.org
      aliases:
        - phabricator.nasqueron.org
      blogs:
        servers:
          host: servers.nasqueron.org
          aliases:
            - server.nasqueron.org
            - serveur.nasqueron.org
            - serveurs.nasqueron.org
      mailer: mailgun
      credentials:
        mysql: zed.phabricator.mysql
      static_host: devcentral.nasqueron-user-content.org
      title: Nasqueron DevCentral
      mysql_link: acquisitariat
      skip_container: True

    # Private instance for Dereckson
    river_sector:
      app_port: 23080
      host: river-sector.dereckson.be
      static_host: river-sector.nasqueron-user-content.org
      mailer: _
      credentials:
        mysql: dereckson.phabricator.mysql
      storage:
        namespace: river_sector
      title: River Sector
      mysql_link: acquisitariat

    # Wolfplex instance
    wolfplex_phab:
      app_port: 35080
      host: phabricator.wolfplex.org
      aliases:
        - phabricator.wolfplex.be
      static_host: wolfplex.phabricator.nasqueron-user-content.org
      mailer: mailgun
      credentials:
        mailgun: wolfplex.phabricator.mailgun
        mysql: wolfplex.phabricator.mysql
      storage:
        namespace: wolfphab
      title: Wolfplex Phabricator
      mysql_link: acquisitariat

    # Zed instance
    zed_code:
      app_port: 36080
      host: code.zed.dereckson.be
      static_host: zed.phabricator.nasqueron-user-content.org
      mailer: sendgrid
      credentials:
        mysql: zed.phabricator.mysql
        sendgrid: zed.phabricator.sendgrid
      storage:
        namespace: zedphab
      title: Zed
      mysql_link: acquisitariat

  aphlict:
    aphlict:
      ports:
        client: 22280
        admin: 22281

  #
  # Notifications center
  #

  notifications:
    notifications:
      host: notifications.nasqueron.org
      app_port: 37080
      broker_link: white-rabbit
      credentials:
        broker: nasqueron.notifications.broker
        mailgun: nasqueron.notifications.mailgun
      sentry:
        realm: nasqueron
        project_id: 2
        credential: nasqueron.notifications.sentry

  #
  # Community and development services
  #

  etherpad:
    pad:
      app_port: 34080
      host: pad.nasqueron.org
      aliases:
        - pad.wolfplex.org
        - pad.wolfplex.be
      credential: nasqueron.etherpad.api
      mysql_link: acquisitariat

  # Hauk
  hauk:
    hauk:
      app_port: 43080
      host: geo.nasqueron.org
      api_entry_point: /hauk

  #
  # Let's Encrypt
  #

  acme_dns:
    acme:
      ip: *ipv4_docker002
      app_port: 41080
      host: acme.nasqueron.org
      nsadmin: ops.nasqueron.org

  #
  # CI and CD
  #

  #
  # Infrastructure and development services
  #

  hound:
    hound:
      app_port: 44080
      host: code.nasqueron.org
      github_account: nasqueron

  cachet:
    cachet:
      app_port: 39080
      host: status.nasqueron.org
      credential: nasqueron.cachet.mysql
      app_key: nasqueron.cachet.app_key
      mysql_link: acquisitariat

  auth-grove:
    login:
      app_port: 25080
      host: login.nasqueron.org
      credential: nasqueron.auth-grove.mysql
      mysql_link: acquisitariat

  # API microservices

  docker-registry-api:
    api-docker-registry:
      app_port: 20080
      api_entry_point: /docker/registry
      registry_instance: registry

  api-datasources:
    api-datasources:
      app_port: 19080
      api_entry_point: /datasources

  # phpBB SaaS
  # The SaaS uses a MySQL instance, declared in the MySQL section.

  # Pixelfed
  pixelfed:
    pixelfed:
      app_port: 30080
      host: photos.nasqueron.org
      aliases:
        - photo.nasqueron.org
      links:
        mysql: acquisitariat
        redis: pixelfed_redis
      credentials:
        app_key: nasqueron.pixelfed.app_key
        mailgun: nasqueron.pixelfed.mailgun
        mysql: nasqueron.pixelfed.mysql
      app:
        title: Nasqueron Photos
        max_album_length: 16
