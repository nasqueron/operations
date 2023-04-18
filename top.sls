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
    - roles/salt-primary
  'ysul':
    - roles/builder
    - roles/dbserver-mysql
    - roles/devserver
    - roles/viperserv
    - roles/webserver-core
    - roles/webserver-legacy
    - roles/webserver-varnish
  'windriver':
    - roles/builder
    - roles/dbserver-mysql
    - roles/dbserver-pgsql
    - roles/devserver
    - roles/webserver-alkane
    - roles/webserver-core
    - roles/webserver-legacy
  'cloudhugger':
    - roles/opensearch
  'db-A-001':
    - roles/dbserver-pgsql
  'db-B-001':
    - roles/dbserver-mysql
  'docker-002':
    - roles/paas-docker
  'dwellers':
    - roles/paas-docker/docker
    - roles/paas-lxc/lxc
  'eglide':
    - roles/webserver-core
    - roles/shellserver
  'web-001':
    - roles/webserver-core
    - roles/webserver-alkane
    - roles/saas-mediawiki
