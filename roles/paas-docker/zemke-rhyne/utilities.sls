#   -------------------------------------------------------------
#   Salt — Provision Docker engine
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2018-09-08
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import dirs with context %}

{{ dirs.bin }}/zr:
  file.managed:
    - source: salt://roles/paas-docker/zemke-rhyne/files/zr.sh
    - mode: 755
