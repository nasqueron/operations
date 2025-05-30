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
    - roles/freebsd-repo # depends of devserver/datacube, builder
    - roles/grafana
    - roles/prometheus
    - roles/redis
    - roles/saas-nextcloud
    - roles/webserver-alkane
    - roles/webserver-core
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
    - roles/saas-airflow
  'eglide':
    - roles/webserver-core
    - roles/shellserver
  'hervil':
    - roles/mailserver
    - roles/webserver-core
    - roles/webserver-alkane
  'web-001':
    - roles/webserver-core
    - roles/webserver-alkane
    - roles/saas-mediawiki
    - roles/saas-wordpress
