#   -------------------------------------------------------------
#   Salt — Deploy Odderon unit (darkbot)
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2017-10-19
#   Description:    Darkbot unit (Freenode)
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

#   -------------------------------------------------------------
#   File permissions and ownership
#   -------------------------------------------------------------

odderon_fix_permissions_and_ownership:
  file.managed:
    - name: /opt/odderon/var/darkbot/userlist.db
    - user: odderon
    - group: nasqueron-irc
    - chmod: 640
    - replace: False
