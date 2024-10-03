#   -------------------------------------------------------------
#   Salt — Provision software
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2017-10-20
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

/opt:
  file.directory

include:
  # FreeBSD ports
  - .ports
  # Shell server content
  - roles/shellserver/userland-software/base
  - roles/shellserver/userland-software/irc
  - roles/shellserver/userland-software/mail
  - roles/shellserver/userland-software/web
  # Builder role content
  - roles/builder
  # salt-primary content
  - roles/salt-primary/salt-wrapper
  # Software specific for development servers
  - .dev
  - .misc
  - .notifications
  - .phabricator
  - .psysh
  - .wordpress
