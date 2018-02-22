#   -------------------------------------------------------------
#   Salt configuration for Nasqueron servers
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2018-02-22
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

roles_disabled:
  paas_jails:
    # T1345
    - ysul
