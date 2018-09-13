#   -------------------------------------------------------------
#   Salt — Provision Docker engine
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2018-09-13
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

include:
  - .salt
  - .docker
  - .zemke-rhyne
  - .containers
  - .systemd-unit
  - .wwwroot-502
  - .nginx
  - .letsencrypt
  - .wrappers
