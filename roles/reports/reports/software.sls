#   -------------------------------------------------------------
#   Salt — Nasqueron Reports
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import dirs, packages_prefixes with context %}

#   -------------------------------------------------------------
#   Repository local copy
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/opt/nasqueron-reports:
  file.directory:
    - user: builder
    - group: deployment
    - mode: 775

nasqueron_reports_repository:
  git.latest:
    - name: https://devcentral.nasqueron.org/source/reports.git
    - target: /opt/nasqueron-reports
    - user: builder
    - force_clone: True

#   -------------------------------------------------------------
#   Python package
#
#   :: dependencies
#   :: build
#   :: installation
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% set site_packages = salt["python.get_site_packages_directory"]() %}
{% set package_wheel_filename = "nasqueron_reports-0.0.0.dev0-py3-none-any.whl" %}

nasqueron_reports_dependencies:
  pkg.installed:
    - pkgs:
      - {{ packages_prefixes.python3 }}hvac
      - {{ packages_prefixes.python3 }}mysql-connector-python
      - {{ packages_prefixes.python3 }}pyyaml
      - {{ packages_prefixes.python3 }}sqlparse

nasqueron_reports_build:
  cmd.script:
    - name: salt://roles/reports/reports/files/build.sh
    - runas: builder
    - creates: /opt/nasqueron-reports/dist/{{ package_wheel_filename }}

nasqueron_reports_install:
  cmd.run:
    - name: |
        pip install /opt/nasqueron-reports/dist/{{ package_wheel_filename }}
    - creates: {{ site_packages }}/nasqueron_reports

#   -------------------------------------------------------------
#   Symlinks for resources at expected locations
#
#   :: config in /etc or /usr/local/etc
#   :: content in /usr/local/share/nasqueron-reports
#   :: utilities in /usr/local/bin
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{{ dirs.etc }}/reports.yaml:
  file.symlink:
    - target: /opt/nasqueron-reports/tools/nasqueron-reports/conf/reports.yaml

/usr/local/share/nasqueron-reports:
  file.directory:
    - user: root
    - group: deployment
    - mode: 775

/usr/local/share/nasqueron-reports/sql:
  file.symlink:
    - target: /opt/nasqueron-reports/sql
    - require:
      - file: /usr/local/share/nasqueron-reports
