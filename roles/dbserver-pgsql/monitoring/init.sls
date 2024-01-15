#   -------------------------------------------------------------
#   Salt — Database server — PostgreSQL
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import packages_prefixes with context %}

{% if grains["os"] == "FreeBSD" %}

#   -------------------------------------------------------------
#   Python dependencies for checks
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

postgresql_monitoring_dependencies:
  pkg.installed:
    - pkgs:
      - {{ packages_prefixes.python3 }}pip
  pip.installed:
    - name: lddcollect
    - require:
      - pkg: postgresql_monitoring_dependencies

#   -------------------------------------------------------------
#   PostgreSQL checks
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/usr/local/bin/check-postgresql-dependencies:
  file.managed:
    - source: salt://roles/dbserver-pgsql/monitoring/files/check-postgresql-dependencies.py
    - mode: 755

/usr/local/bin/check-postgresql-xml-support:
  file.managed:
    - source: salt://roles/dbserver-pgsql/monitoring/files/check-postgresql-xml-support.py
    - mode: 755

{% endif %}
