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
  'local':
    - roles/saltmaster
  'ysul':
    - roles/paas-jails
    - roles/webserver-core
    - roles/webserver-legacy
    - roles/webserver-varnish
  'dwellers':
    - roles/paas-docker/docker
    - roles/paas-lxc/lxc
    - roles/mastodon
  'eglide':
    - roles/webserver-core
    - roles/shellserver/users
    - roles/shellserver/userland-software
    - roles/shellserver/eglide-website
    - roles/shellserver/vhosts
    - roles/shellserver/web-hosting
    - roles/shellserver/database
    - roles/shellserver/odderon
    - roles/shellserver/bonjour-chaton
