#   -------------------------------------------------------------
#   Salt — Provision a development server
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2017-10-20
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
