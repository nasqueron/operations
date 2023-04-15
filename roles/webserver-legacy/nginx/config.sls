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

webserver_legacy_nginx_includes:
  file.recurse:
    - name: {{ dirs.etc }}/nginx/includes
    - source: salt://roles/webserver-legacy/nginx/files/includes
    - dir_mode: 755
    - file_mode: 644

#   -------------------------------------------------------------
#   vhosts folder
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

webserver_legacy_nginx_vhosts:
  file.recurse:
    - name: {{ dirs.etc }}/nginx/vhosts
    - source: salt://roles/webserver-legacy/nginx/files/vhosts
    - dir_mode: 755
    - file_mode: 644
    - template: jinja
    - context:
        services: {{ pillar["nasqueron_services"] }}
