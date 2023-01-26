#   -------------------------------------------------------------
#   Salt — Database server — PostgreSQL
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import packages with context %}

#   -------------------------------------------------------------
#   PostgreSQL server
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

postgresql_server_software:
  pkg.installed:
    - pkgs:
      - {{ packages.postgresql }}
      {% if pillar["dbserver_postgresql"]["server"]["with_contrib"] | default(False) %}
      - {{ packages["postgresql-contrib"] }}
      {% endif %}

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
