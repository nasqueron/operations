#   -------------------------------------------------------------
#   Salt — Sites to provision on the legacy web server
#
#   Currently, this is deployed to ysul.nasqueron.org
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

include:
  - .account
  - .directories
  - .nginx
  - .static-sites
  - .php-sites
  - .tweaks
