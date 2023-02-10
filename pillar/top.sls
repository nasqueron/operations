#   -------------------------------------------------------------
#   Salt configuration for Nasqueron servers
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2016-04-10
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

base:
  '*':
    - core.users
    - core.groups
    - core.network
    - certificates.certificates
    - nodes.nodes
    - nodes.forests
    - hotfixes.roles
    - services.monitoring-reporting
    - webserver.sites

  cloudhugger:
    - opensearch.software
    - opensearch.clusters

  complector:
    - credentials.vault

    # To provision services
    - saas.rabbitmq

  docker-002:
    - notifications.config
    - paas.docker
    - saas.jenkins
    - saas.phpbb

  db-A-001:
    - dbserver.cluster-A

  dwellers:
    - paas.docker
    - saas.jenkins

  eglide:
    - shellserver.quassel

  ysul:
    - devserver.repos
    - saas.mediawiki
    - viperserv.bots
    - viperserv.fantoir
    - webserver.labs
    - webserver.wwwroot51

  windriver:
    - devserver.ports
    - devserver.repos
    - webserver.labs
    - webserver.wwwroot51
