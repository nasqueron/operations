#   -------------------------------------------------------------
#   Salt configuration for Nasqueron servers
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2016-04-10
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

base:
  '*':
    - roles/core/rc
    - roles/core/hostname
    - roles/core/network
    - roles/core/motd
    - roles/core/rsyslog
    - roles/core/salt
    - roles/core/sshd
    - roles/core/sysctl
    - roles/core/users
  'local':
    - roles/saltmaster
  'ysul':
    - roles/paas-jails
    - roles/dbserver-mysql
    - roles/webserver-core
    - roles/webserver-legacy
    - roles/webserver-varnish
  'dwellers':
    - roles/paas-docker/docker
    - roles/paas-lxc/lxc
    - roles/mastodon
  'eglide':
    - roles/webserver-core
    - roles/shellserver/userland-software
    - roles/shellserver/eglide-website
    - roles/shellserver/vhosts
    - roles/shellserver/web-hosting
    - roles/shellserver/database
    - roles/shellserver/odderon
    - roles/shellserver/bonjour-chaton
