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
{% if 'repository' not in site %}
    - user: {{ site['user'] }}
    - group: {{ site['group'] }}
{% else %}
    # Credentials belong to deploy user
    - user: deploy

  git.latest:
    - name: {{ site['repository'] }}
    - target: {{ basedir }}/{{ sitename }}
    - user: deploy
    - identity: /opt/salt/security/id_ed25519
    - update_head: False

fix_rights_{{ basedir }}/{{ sitename }}:
  file.directory:
    - name: {{ basedir }}/{{ sitename }}
    - user: {{ site['user'] }}
    - group: {{ site['group'] }}
    - recurse:
      - user
      - group
    - onchanges:
      - git: {{ basedir }}/{{ sitename }}    

{% endif %}
{% endfor %}
