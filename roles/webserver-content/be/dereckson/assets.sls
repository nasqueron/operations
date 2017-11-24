#   -------------------------------------------------------------
#   Salt — Provision assets.dereckson.be website
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        DcK Area
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% if salt['node.has_web_content'](".org/nasqueron/assets") %}

#   -------------------------------------------------------------
#   Deploy /opt/staging/wwwroot/d.be/assets to assets.d.be
#
#   !!! WARNING !!!
#   This folder could contain non staged resources. As such,
#   clean must be let at False.
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/var/wwwroot/dereckson.be/assets:
  file.recurse:
    - source: salt://wwwroot/dereckson.be/assets
    - exclude_pat: E@.git
    - include_empty: True
    - clean: False
    - dir_mode: 755
    - file_mode: 644
    - user: dereckson.be
    - group: web

{% endif %}
