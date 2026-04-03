#   -------------------------------------------------------------
#   Salt — Provision a development server
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

include:
  - .datacube
  - .dns
  - .mail
  - .pkg
  - .userland-software
  - .userland-home
  - .poudriere

  # Needs userland-software
  - .api-exec

  - .webserver-home
  - .webserver-wwwroot51
