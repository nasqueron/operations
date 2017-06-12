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
    - roles/core/letsencrypt
  'local':
    - roles/saltmaster/sudo
  'dwellers.nasqueron.org':
    - roles/paas-docker/docker
    - roles/paas-lxc/lxc
  'eglide':
    - roles/shellserver/users
    - roles/shellserver/userland-software
    - roles/shellserver/eglide-website
    - roles/shellserver/vhosts
    - roles/shellserver/web-hosting
    - roles/shellserver/odderon
