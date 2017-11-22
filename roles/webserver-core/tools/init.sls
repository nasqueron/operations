#   -------------------------------------------------------------
#   Salt — Helper tools for nginx
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2017-10-24
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import dirs with context %}

{{ dirs.bin }}/list-nginx-vhosts-conf:
  file.managed:
    - mode: 755
    - source: salt://roles/webserver-core/tools/files/list-nginx-vhosts.tcl

{{ dirs.bin }}/autochmod:
  file.managed:
    - mode: 755
    - source: salt://roles/webserver-core/tools/files/autochmod.sh
