#   -------------------------------------------------------------
#   Salt — Database server — MySQL
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

include:
  - .mysql-server
  - .grc
  - .treasure-chest
  - .salt

  # Requires .mysql-server and .salt
  - .content
