#   -------------------------------------------------------------
#   Salt — Webserver core units for all webservers roles
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
#   -------------------------------------------------------------

webserver_core_nginx_includes:
  file.recurse:
    - name: {{ dirs.etc }}/nginx/includes
    - source: salt://roles/webserver-core/nginx/files/includes
    - dir_mode: 755
    - file_mode: 644
