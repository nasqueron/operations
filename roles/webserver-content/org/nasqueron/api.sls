#   -------------------------------------------------------------
#   Salt — Provision api.nasqueron.org website
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% if salt['node.has_web_content'](".org/nasqueron/api") %}

#   -------------------------------------------------------------
#   Base  part from rOPS
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/var/wwwroot/nasqueron.org/api:
  file.recurse:
    - source: salt://wwwroot/nasqueron.org/api
    - exclude_pat: E@.git
    - include_empty: True
    - clean: False
    - dir_mode: 755
    - file_mode: 644
    - user: deploy
    - group: web

{% endif %}
