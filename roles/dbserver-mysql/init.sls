#   -------------------------------------------------------------
#   Salt — Database server — MySQL
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2017-10-27
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

include:
  - .mysql-server
  - .grc
  - .treasure-chest
  - .salt

  # Requires .mysql-server and .salt
  - .content
