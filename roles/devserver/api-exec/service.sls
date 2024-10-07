#   -------------------------------------------------------------
#   API :: api-exec
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import dirs, services with context %}

{% if services["manager"] == "rc" %}

{{ dirs.etc }}/rc.d/api_exec:
  file.managed:
    - source: salt://roles/devserver/api-exec/files/rc/api_exec
    - mode: 755

/etc/rc.conf.d/api_exec:
  file.managed:
    - source: salt://roles/devserver/api-exec/files/rc/api_exec.conf

{% endif %}
