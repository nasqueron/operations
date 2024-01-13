#   -------------------------------------------------------------
#   Salt — Provision a salt primary server
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import services with context %}

#   -------------------------------------------------------------
#   Enable FreeBSD service
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% if services["manager"] == "rc" %}

/etc/rc.conf.d/salt_api:
  file.managed:
    - source: salt://roles/salt-primary/api/files/salt_api.rc

{% endif %}

#   -------------------------------------------------------------
#   Start service
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

service_salt_api:
  service.running:
    - name: salt_api
    - enable: true
