#   -------------------------------------------------------------
#   Salt — Service
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2018-10-16
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import dirs, services with context %}

#   -------------------------------------------------------------
#   rc :: ensure master runs in UTF-8
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% if services['manager'] == "rc" %}

{{ dirs.etc }}/rc.d/salt_master:
  file.patch:
    - source: salt://roles/saltmaster/service/files/rc.patch
    - hash: 08559af1d8b2d24f762085421a563602

{% endif %}
