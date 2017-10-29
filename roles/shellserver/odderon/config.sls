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
  cmd.run:
    - names:
      - chown odderon:nasqueron-irc /opt/odderon/var/darkbot/userlist.db
      - chmod 640 /opt/odderon/var/darkbot/userlist.db
