#   -------------------------------------------------------------
#   Salt — Database server — PostgreSQL
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

#   -------------------------------------------------------------
#   PostgreSQL service
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% if grains['os'] == 'FreeBSD' %}

/etc/rc.conf.d/postgresql:
  file.managed:
    - source: salt://roles/dbserver-pgsql/server/files/postgresql.rc

initialize_postgresql:
  cmd.run:
    - name: /usr/local/etc/rc.d/postgresql initdb
    - creates: /var/db/postgres/data

postgresql_running:
  service.running:
    - name: postgresql

{% endif %}
