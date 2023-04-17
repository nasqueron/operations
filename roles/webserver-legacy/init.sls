#   -------------------------------------------------------------
#   Salt — Sites to provision on the legacy web server
#
#   Currently, this is deployed to ysul.nasqueron.org
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

include:
  - roles/webserver-alkane/account
  - roles/webserver-alkane/directories
  - .nginx
  - .static-sites
  - .php-sites
  - .tweaks
