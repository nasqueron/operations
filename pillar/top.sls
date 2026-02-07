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

  db-A-001:
    - dbserver.cluster-A

  db-B-001:
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
