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
    - certificates.certificates
    - nodes.nodes
    - nodes.forests
    - hotfixes.roles
    - webserver.sites
  ysul:
    - viperserv.bots
    - viperserv.fantoir
    - webserver.labs
    - webserver.wwwroot51
