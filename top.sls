#   -------------------------------------------------------------
#   Salt configuration for Nasqueron servers
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2016-04-10
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

base:
  '*':
    - roles/core
    - roles/webserver-content
  'local':
    - roles/saltmaster
  'ysul':
    - roles/dbserver-mysql
    - roles/devserver
    - roles/viperserv
    - roles/webserver-core
    - roles/webserver-legacy
    - roles/webserver-varnish
  'dwellers':
    - roles/paas-docker/docker
    - roles/paas-lxc/lxc
  'eglide':
    - roles/webserver-core
    - roles/shellserver
  'equatower':
    - roles/paas-docker
