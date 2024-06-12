#   -------------------------------------------------------------
#   Salt — Provision labs.nasqueron.org website
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

#   -------------------------------------------------------------
#   Base directory
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/var/wwwroot/nasqueron.org/labs:
  file.directory:
    - user: deploy
    - group: web
    - dir_mode: 755

labs_base_directory_content:
  file.recurse:
    - name: /var/wwwroot/nasqueron.org/labs
    - source: salt://wwwroot/nasqueron.org/labs/public
    - exclude_pat: E@.git
    - user: deploy
    - group: web
    - dir_mode: 755
    - file_mode: 644
    - clean: False

#   -------------------------------------------------------------
#   Labs directories
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% for lab in pillar['web_labs'] %}
labs_lab_directory_{{ lab }}:
  file.recurse:
    - name: /var/wwwroot/nasqueron.org/labs/{{ lab }}
    - source: salt://software/{{ lab }}
    - exclude_pat: E@.git
    - user: deploy
    - group: web
    - dir_mode: 755
    - file_mode: 644
    - clean: False
{% endfor %}
