#   -------------------------------------------------------------
#   Salt — Database server — PostgreSQL
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

#   -------------------------------------------------------------
#   PostgreSQL general configuration
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/var/db/postgres/data/pg_hba.conf:
  file.managed:
    - source: salt://roles/dbserver-pgsql/server/files/pg_hba.conf
    - mode: 444
    - template: jinja
    - context:
        connections: {{ pillar["dbserver_postgresql"]["connections"] }}

/var/db/postgres/data/postgresql.conf:
  file.managed:
    - source: salt://roles/dbserver-pgsql/server/files/postgresql.conf
    - mode: 444
    - template: jinja
    - context:
        server: {{ pillar["dbserver_postgresql"]["server"] }}
