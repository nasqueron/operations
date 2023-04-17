#   -------------------------------------------------------------
#   Salt — Provision PHP websites
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

include:
  - .files
  - .php
  - .php-fpm
  - roles/webserver-alkane/php/service
  - roles/webserver-alkane/php/cleanup
