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
