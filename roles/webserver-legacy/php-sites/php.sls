#   -------------------------------------------------------------
#   Salt — Provision PHP websites — php-fpm pools
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import dirs with context %}

#   -------------------------------------------------------------
#   PHP global configuration
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{{ dirs.etc }}/php.ini:
  file.managed:
    - source: salt://roles/webserver-legacy/php-sites/files/php.ini

#   -------------------------------------------------------------
#   Session directory
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/var/tmp/php:
  file.directory:
    - mode: 1770
    - group: web

/var/tmp/php/sessions:
  file.directory:
    - mode: 1770
    - group: web
