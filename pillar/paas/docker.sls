#   -------------------------------------------------------------
#   Salt — Provision Docker engine
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2018-03-10
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

docker_aliases:
  - &ipv4_docker001 51.255.124.9
  - &ipv4_docker001_restricted 51.255.124.9

#   -------------------------------------------------------------
#   Images
#
#   You can append a :tag (by default, latest is used).
#
#   It's not possible to specify Docker library images only by final name.
#   See https://docs.saltstack.com/en/latest/ref/states/all/salt.states.docker_image.html
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

docker_images:
  '*':
    - certbot/certbot

  dwellers:
    # Core services
    - nasqueron/mysql:5.7

    # Infrastructure and development services
    - nasqueron/notifications

  docker-001:
    # Core services
    - library/postgres
    - library/redis:3.2-alpine
    - library/registry
    - nasqueron/mysql
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
    - nasqueron/phabricator

    # Continuous deployment jobs
    - jenkins/jenkins
    - nasqueron/jenkins-slave-node
    - nasqueron/jenkins-slave-php
    - nasqueron/jenkins-slave-rust
    - nasqueron/tommy

    # Pixelfed
    - nasqueron/pixelfed

    # Sentry
    - library/sentry
    - tianon/exim4

#   -------------------------------------------------------------
#   Networks
#
#   Containers can be grouped by network, instead to use links.
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

docker_networks:
  dwellers:
    bugzilla:
      subnet: 172.21.3.0/24
  docker-001:
    cd:
      subnet: 172.18.1.0/24
    ci:
      subnet: 172.18.2.0/24

#   -------------------------------------------------------------
#   Docker engine configuration
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

docker_daemon:
  docker-001:
    storage-driver: devicemapper
    storage-opts:
        - "dm.thinpooldev=/dev/mapper/wharf-thinpool"
        - "dm.use_deferred_removal=true"
        - "dm.use_deferred_deletion=true"

docker_devicemapper:
  docker-001:
    thinpool: wharf-thinpool

#   -------------------------------------------------------------
#   Containers
#
#   The docker_containers entry allow to declare
#   containers by image by servers
#
#   The hierarchy is so as following.
#
#   docker_containers:
#     server with the Docker engine:
#       service codename:
#         instance name:
#            container properties
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
  # Dwellers is the engine for Mastodon and CI intelligent bus services
  #
  dwellers:

    #
    # Core services
    #

    mysql:
      bugzilla_db:
        network: bugzilla
        version: 5.7

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
    # Bugzilla
    #

    bugzilla:
      ew_bugzilla:
        host: bugzilla.espace-win.org
        app_port: 33080
        network: bugzilla
        mysql:
          host: bugzilla_db
          db: EspaceWin_Bugs
        credential: espacewin.bugzilla.mysql

    #
    # Mastodon
    #

    # Mastodon is currently deployed manually through docker-compose
    # and not yet integrated to the platform. This declaration is
    # currently only used for extra utilities deployment.

    mastodon_sidekiq:
      mastodon_sidekiq_1:
        realm: nasqueron

  #
  # Current production engine
  #
  docker-001:

    #
    # Core services
    #

    mysql:
      acquisitariat: {}
      phpbb_db: {}

    postgresql:
      sentry_db:
        credential: nasqueron.sentry.postgresql

    rabbitmq:
      white-rabbit:
        ip: *ipv4_docker001_restricted
        host: white-rabbit.nasqueron.org
        app_port: 15672

    redis:
      sentry_redis: {}
      pixelfed_redis: {}

    registry:
      registry:
        host: registry.nasqueron.org
        app_port: 5000
        allowed_ips:
          # Localhost
          - 127.0.0.1

          # Dwellers
          - 51.255.124.11
          - 2001:470:1f13:ce7:ca5:cade:fab:1e

          # docker-001
          - 51.255.124.9
          - 2001:470:1f13:365::50f7:ba11

    #
    # Let's Encrypt
    #

    acme_dns:
      acme:
        ip: *ipv4_docker001
        app_port: 41080
        host: acme.nasqueron.org
        nsadmin: ops.nasqueron.org

    #
    # CI and CD
    #

    jenkins:
      jenkins_cd:
        realm: cd
        host: cd.nasqueron.org
        app_port: 38080
        jnlp_port: 50000
      jenkins_ci:
        realm: ci
        host: ci.nasqueron.org
        app_port: 42080
        jnlp_port: 55000

    jenkins_slave:
      # Slaves for CD
      apsile: &php_for_cd
        image: php
        realm: cd

      elapsi: *php_for_cd

      rust_brown:
        image: rust
        realm: cd

      yarabokin:
        image: node
        realm: cd

      zateki: &php_for_ci
        image: php
        realm: ci

      zenerre: *php_for_ci

    tommy:
      tommy_ci:
        app_port: 24080
        host: builds.nasqueron.org
        aliases:
          - build.nasqueron.org
        jenkins_url: https://ci.nasqueron.org

      tommy_cd:
        # No host definition, as this dashboard is mounted on infra.nasqueron.org
        app_port: 24180
        jenkins_url: https://cd.nasqueron.org

    # Infrastructure and development services

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

    cachet:
      cachet:
        app_port: 39080
        host: status.nasqueron.org
        credential: nasqueron.cachet.mysql
        app_key: nasqueron.cachet.app_key
        mysql_link: acquisitariat

    etherpad:
      pad:
        app_port: 34080
        host: pad.nasqueron.org
        aliases:
          - pad.wolfplex.org
          - pad.wolfplex.be
        credential: nasqueron.etherpad.api
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

    # Openfire
    openfire:
      openfire:
        ip: *ipv4_docker001
        app_port: 9090
        host: xmpp.nasqueron.org

        # Other subservices for XMPP
        # listening to their own subdomain
        aliases:
          - conference.nasqueron.org

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

    # Sentry
    # The Sentry instance uses a Redis and a PostgreSQL instance,
    # declared above.
    exim:
      sentry_smtp:
        mailname: mx.sentry.nasqueron.org

    sentry:
      sentry_web_1:
        app_port: 26080
        host: sentry.nasqueron.org

        # As an instance is divided between a web, a cron and a worker
        # containers, we need an identified to share a data volume.
        realm: nasqueron

    sentry_worker:
      sentry_worker_1:
        realm: nasqueron

    sentry_cron:
      sentry_cron:
        realm: nasqueron

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

xmpp_ports:
  - 3478
  - 5222 # Client to server
  - 5223 # Client to server (Encrypted (legacy-mode) connections)
  - 5229 # Flash Cross Domain
  - 5262 # Connections managers
  - 5269 # Server to server
  - 5270 # Server to server (Encrypted (legacy-mode) connections)
  - 5275 # External components
  - 5276 # External components (Encrypted (legacy-mode) connections)
  - 7070 # HTTP binding
  - 7443 # HTTP binding with TLS
  - 7777 # File transfer proxy
  - 9090 # Web administration server
  - 9091 # Web administration server with TLS

 #   -------------------------------------------------------------
 #   Zemke-Rhyne clients
 #
 #   This section should list all the Docker engines server
 #   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

zr_clients:
  - key: 2
    allowedConnectionFrom:
      - 172.27.26.49
      - dwellers.nasqueron.drake
      - dwellers.nasqueron.org
    restrictCommand:
    comment: Zemke-Rhyne

  - key: 152
    allowedConnectionFrom:
      - docker-001.nasqueron.org
    restrictCommand:
    comment: Zemke-Rhyne
