#   -------------------------------------------------------------
#   Salt — Deploy eggdrop park
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

/srv/viperserv/user-config.py:
  file.managed:
    - source: salt://roles/viperserv/wikidata-access-layer/files/user-config.py
    - user: viperserv
    - group: nasqueron-irc
    - chmod: 644
