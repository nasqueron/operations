#   -------------------------------------------------------------
#   Salt configuration for Nasqueron servers
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2016-04-10
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

base:
  '*':
    - core.hostnames
    - core.users
    - core.groups
    - certificates.certificates
    - nodes.nodes
    - nodes.forests
  ysul:
    - paas-jails.jails
    - webserver-legacy.sites
    - viperserv.bots
    - viperserv.fantoir
