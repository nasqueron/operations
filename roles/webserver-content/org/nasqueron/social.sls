#   -------------------------------------------------------------
#   Salt — Provision social.nasqueron.org public directories
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

/srv/data/mastodon/public/support:
  file.recurse:
    - source: salt://wwwroot/nasqueron.org/mastodon/support
    - exclude_pat: E@.git
    - include_empty: True
    - clean: True
    - dir_mode: 711
    - file_mode: 644
