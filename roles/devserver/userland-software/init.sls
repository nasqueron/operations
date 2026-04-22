#   -------------------------------------------------------------
#   Salt — Provision software
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

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
  - .tex
  - .wordpress
