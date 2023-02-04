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
    - webserver.sites

  cloudhugger:
    - credentials.zr
    - opensearch.software
    - opensearch.clusters

  complector:
    - credentials.vault

  docker-002:
    - notifications.config
    - paas.docker
    - saas.jenkins
    - saas.phpbb
    - saas.sentry

  db-A-001:
    - dbserver.cluster-A

  dwellers:
    - credentials.zr
    - paas.docker
    - saas.jenkins
    - saas.sentry

  eglide:
    - shellserver.quassel

  ysul:
    - devserver.repos
    - credentials.zr
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
