#   -------------------------------------------------------------
#   Salt — Sites to provision on the legacy web server
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import dirs with context %}

#   -------------------------------------------------------------
#   includes folder
#
#    :: general configuration
#    :: application-specific code
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

webserver_alkane_nginx_includes:
  file.recurse:
    - name: {{ dirs.etc }}/nginx/includes
    - source: salt://roles/webserver-alkane/nginx/files/includes
    - dir_mode: 755
    - file_mode: 644

#   -------------------------------------------------------------
#   vhosts folder
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{{ dirs.etc }}/nginx/vhosts:
  file.directory:
    - mode: 711

{% for domain, subdomains in pillar["nginx_vhosts"].items() %}

{{ dirs.etc }}/nginx/vhosts/{{ domain }}:
  file.directory:
    - mode: 711

{% for subdomain in subdomains %}
{{ dirs.etc }}/nginx/vhosts/{{ domain }}/{{ subdomain }}.conf:
  file.managed:
    - source: salt://roles/webserver-alkane/nginx/files/vhosts/{{ domain }}/{{ subdomain }}.conf
    - mode: 644
    - template: jinja
    - context:
        services: {{ pillar["nasqueron_services"] }}
{% endfor %}

{% endfor %}

#   -------------------------------------------------------------
#   Log
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/etc/newsyslog.conf.d/nginx.conf:
  file.managed:
    - source: salt://roles/webserver-alkane/nginx/files/newsyslog/nginx.conf
