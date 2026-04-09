#   -------------------------------------------------------------
#   Salt — Router — FRRouting
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import services with context %}

{% if services.manager == "rc" %}

/etc/rc.conf.d/frr:
  file.managed:
    - source: salt://roles/router/frrouting/files/frr.rc
    - mode: 644

{% endif %}
