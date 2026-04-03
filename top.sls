#   -------------------------------------------------------------
#   Salt configuration for Nasqueron servers
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
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
    - roles/webserver-core
    - roles/webserver-legacy
    - roles/webserver-varnish
  'windriver':
    - roles/builder
    - roles/dbserver-mysql
    - roles/dbserver-pgsql
    - roles/devserver
    - roles/dns
    - roles/freebsd-repo # depends of devserver/datacube, builder
    - roles/grafana
    - roles/netbox
    - roles/prometheus
    - roles/redis
    - roles/reports # depends of builder
    - roles/saas-nextcloud
    - roles/viperserv
    - roles/webserver-alkane
    - roles/webserver-core
  'cloudhugger':
    - roles/opensearch
  'db-a-001':
    - roles/dbserver-pgsql
  'db-b-001':
    - roles/dbserver-mysql
  'dns-001':
    - roles/dns
  'docker-002':
    - roles/paas-docker
  'dwellers':
    - roles/paas-docker
    - roles/paas-lxc/lxc
    - roles/saas-airflow
  'eglide':
    - roles/webserver-core
    - roles/shellserver
  'hervil':
    - roles/mailserver
    - roles/webserver-core
    - roles/webserver-alkane
  'router-002':
    - roles/router
  'router-003':
    - roles/router
  'web-001':
    - roles/webserver-core
    - roles/webserver-alkane
    - roles/saas-mediawiki
    - roles/saas-wordpress
