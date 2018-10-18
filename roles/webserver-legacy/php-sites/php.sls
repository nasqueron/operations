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

{% for build in pillar['php_custom_builds'] %}
/opt/php/{{ build }}/lib/php.ini:
  file.managed:
    - source: salt://roles/webserver-legacy/php-sites/files/php.ini
{% endfor %}

#   -------------------------------------------------------------
#   Sessions directories
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/var/tmp/php:
  file.directory:
    - mode: 1770
    - group: web

/var/tmp/php/sessions:
  file.directory:
    - mode: 1770
    - group: web

{% for fqdn, site in pillar['web_php_sites'].items() %}
/var/tmp/php/sessions/{{ fqdn }}:
  file.directory:
    - mode: 0700
    - user: {{ site['user']}}
{% endfor %}
