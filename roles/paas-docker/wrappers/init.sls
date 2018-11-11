#   -------------------------------------------------------------
#   Salt — Provision Docker engine
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2018-03-15
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import dirs with context %}

#   -------------------------------------------------------------
#   Wrapper binaries
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% for command in ['certbot', 'phpbb', 'mysql', 'sentry'] %}
{{ dirs.bin }}/{{ command }}:
  file.managed:
    - source: salt://roles/paas-docker/wrappers/files/{{ command }}.sh
    - mode: 755
{% endfor %}

{% for command in ['pad-delete'] %}
{{ dirs.bin }}/{{ command }}:
  file.managed:
    - source: salt://roles/paas-docker/wrappers/files/{{ command }}.py
    - mode: 755
{% endfor %}
