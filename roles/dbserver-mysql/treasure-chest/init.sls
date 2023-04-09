#   -------------------------------------------------------------
#   Salt — Database server — MySQL
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   Description:    A treasure chest to store databases we can
#                   restore if needed. Those databases are no
#                   longer in use but may contain valuable data
#                   or serve to our inheritance.
#   -------------------------------------------------------------

{% from "map.jinja" import dirs with context %}

#   -------------------------------------------------------------
#   X marks the spot.
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/var/backups/db-treasure-chest:
  file.directory:
    - user: root
    - mode: 700

/var/backups/db-treasure-chest/_restored:
  file.directory:
    - user: root
    - mode: 700

#   -------------------------------------------------------------
#   Found something? Here is the shovel.
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{{ dirs.bin }}/db-treasure-import:
  file.managed:
    - source: salt://roles/dbserver-mysql/treasure-chest/files/db-treasure-import.sh
    - mode: 755
