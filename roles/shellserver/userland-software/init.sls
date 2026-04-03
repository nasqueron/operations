#   -------------------------------------------------------------
#   Salt — Provision software
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Eglide
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

include:
  - roles/builder/account
  - .base
  - .openssl-legacy
  - .irc
  - .mail
  - .web
