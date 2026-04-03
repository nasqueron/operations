#   -------------------------------------------------------------
#   Salt — Provision a salt primary server
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

include:
  - .software
  - .config
  - .account
  - .cloud
  - .staging
  - .salt-wrapper
  - .api
  - .reactor
  - .opentofu
