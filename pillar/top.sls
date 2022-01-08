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

  cloudhugger: []

  docker-001:
    - credentials.zr
    - paas.docker
    - saas.jenkins
    - saas.phpbb
    - saas.sentry

  dwellers:
    - credentials.zr
    - paas.docker
    - saas.sentry

  eglide:
    - shellserver.quassel

  equatower:
    - credentials.zr
    - paas.docker
    - saas.jenkins
    - saas.phpbb
    - saas.sentry

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
