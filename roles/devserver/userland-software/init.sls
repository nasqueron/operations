#   -------------------------------------------------------------
#   Salt — Provision software
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2017-10-20
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

include:
  # Shell server content
  - roles/shellserver/userland-software/base
  - roles/shellserver/userland-software/irc
  - roles/shellserver/userland-software/web
  # Software specific for development servers
  - .dev
  - .misc
  - .phabricator