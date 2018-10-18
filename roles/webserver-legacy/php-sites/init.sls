#   -------------------------------------------------------------
#   Salt — Provision PHP websites
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

include:
  - .account
  - .files
  - .php
  - .php-fpm
  - .cleanup
