#   -------------------------------------------------------------
#   Salt — Provision a salt master
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2017-10-21
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

include:
  - .software
  - .account
  - .cloud
  - .staging
  - .salt-wrapper
