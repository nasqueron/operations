#   -------------------------------------------------------------
#   Salt — Provision social.nasqueron.org public directories
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2017-10-13
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% if salt['node.has_web_content'](".org/nasqueron/social") %}

/srv/data/mastodon/public/support:
  file.recurse:
    - source: salt://wwwroot/nasqueron.org/mastodon/support
    - exclude_pat: E@.git
    - include_empty: True
    - clean: True
    - dir_mode: 711
    - file_mode: 644

{% endif %}
