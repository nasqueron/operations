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
    - certificates.certificates
    - nodes.nodes
  ysul:
    - paas-jails.jails
    - webserver-legacy.sites
  eglide:
    - users.revokedusers
    - users.shellusers
    - users.shellgroups
