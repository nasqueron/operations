#   -------------------------------------------------------------
#   Salt — Shell server's units
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

include:
  # System features
  - .userland-software
  - .vhosts
  - .web-hosting
  - .database

  # Services hosted
  - .odderon
  - .bonjour-chaton
