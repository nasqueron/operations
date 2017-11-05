#   -------------------------------------------------------------
#   Salt — Database server — MySQL
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2017-10-27
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import packages with context %}

#   -------------------------------------------------------------
#   MySQL server
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

mysql_server_software:
  pkg.installed:
    - pkgs:
      - {{ packages.mariadb }}
