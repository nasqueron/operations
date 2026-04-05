#   -------------------------------------------------------------
#   Salt — Mail
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

include:
  - .dovecot
  - .dkim
  - .postfix
  - .vimbadmin

  # Depends on all software installed
  - .coordination
  - .monitoring
