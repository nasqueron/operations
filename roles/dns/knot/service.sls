#   -------------------------------------------------------------
#   Salt — knotDNS service
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import dirs, services with context %}

#   -------------------------------------------------------------
#   OpenDKIM service
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% if services["manager"] == "rc" %}

/etc/rc.conf.d/knot:
  file.managed:
    - source: salt://roles/dns/knot/files/rc/knot.conf

{% endif %}

knot:
  service.running:
    - enable: True
