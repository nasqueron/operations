#   -------------------------------------------------------------
#   Salt — Service
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2018-10-16
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import dirs, services with context %}

#   -------------------------------------------------------------
#   rc :: ensure primary service runs in UTF-8
#
#   Disclaimer: FreeBSD port for Salt still uses "salt_master".
#               This service name is kept for compatibility,
#               but isn't an endorsement of such terminology.
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% if services['manager'] == "rc" %}

{{ dirs.etc }}/rc.d/salt_master:
  file.patch:
    - source: salt://roles/salt-primary/service/files/rc.patch
    - hash: 08559af1d8b2d24f762085421a563602

{% endif %}
