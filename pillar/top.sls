#   -------------------------------------------------------------
#   Salt configuration for Nasqueron servers
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

base:
  '*':
    - core.users
    - core.groups
    - core.network
    - core.ntp
    - nodes.nodes
    - nodes.forests
    - hotfixes.roles
    - services.monitoring-reporting
    - services.table
    - webserver.sites

    - credentials.vault

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

  db-a-001:
    - dbserver.cluster-A

  db-b-001:
    - dbserver.cluster-B

  dwellers:
    - paas.docker
    - saas.airflow
    - saas.jenkins

  eglide:
    - shellserver.quassel

  hervil:
    - mailserver.vimbadmin
    - mailserver.dovecot
    - mailserver.postfix

  ysul:
    - devserver.repos
    - devserver.ports
    - saas.mediawiki
    - webserver.labs
    - webserver.wwwroot51

  web-001:
    - saas.mediawiki
    - saas.wordpress

  windriver:
    - devserver.datacubes
    - devserver.ports
    - devserver.repos
    - netbox.netbox
    - observability.prometheus
    - packages.freebsd
    - viperserv.bots
    - viperserv.fantoir
    - webserver.labs
    - webserver.wwwroot51
