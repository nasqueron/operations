#   -------------------------------------------------------------
#   Netbox
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import services, dirs with context %}

#   -------------------------------------------------------------
#   Service wrapper
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/srv/netbox/service.sh:
  file.managed:
    - source: salt://roles/netbox/netbox/files/service.sh
    - mode: 755

#   -------------------------------------------------------------
#   RC service
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% if services["manager"] == "rc" %}

{{ dirs.etc }}/rc.d/netbox:
  file.managed:
    - source: salt://roles/netbox/netbox/files/rc/netbox
    - mode: 755
    - template: jinja
    - context:
        app_port: {{ pillar["netbox"]["app_port"] }}

/etc/rc.conf.d/netbox:
  file.managed:
    - source: salt://roles/netbox/netbox/files/rc/netbox.rc

{% endif %}
