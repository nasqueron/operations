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
  'eglide':
    - roles/shellserver/users
    - roles/shellserver/userland-software
