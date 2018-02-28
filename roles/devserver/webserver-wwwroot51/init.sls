#   -------------------------------------------------------------
#   Salt — Webserver wwwroot51 content
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2018-02-11
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% set basedir = pillar['wwwroot51_basedir'] %}

#   -------------------------------------------------------------
#   Base directory
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{{ basedir }}:
  file.directory:
    - dir_mode: 711

#   -------------------------------------------------------------
#   51 sites
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% for sitename, site in pillar['wwwroot51_directories'].items() %}
{{ basedir }}/{{ sitename }}:
  file.directory:
    - dir_mode: 711
    - user: {{ site['user'] }}
    - group: {{ site['group'] }}
  git.latest:
    - name: {{ site['repository'] }}
    - target: {{ basedir }}/{{ sitename }}
    - user: {{ site['user'] }}
    - update_head: False
{% endfor %}
