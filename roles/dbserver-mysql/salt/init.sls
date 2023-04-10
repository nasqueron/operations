#   -------------------------------------------------------------
#   Salt — Database server — MySQL
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import dirs, packages_prefixes with context %}

#   -------------------------------------------------------------
#   Required software
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{{ packages_prefixes.python3 }}pymysql:
  pkg.installed:
    - reload_modules: true

#   -------------------------------------------------------------
#   Salt node configuration file
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% set salt_credential = salt["pillar.get"]("dbserver_mysql:server:salt:credentials") %}

{{ dirs.etc }}/salt/minion.d/mysql:
  file.managed:
    - source: salt://roles/dbserver-mysql/salt/files/mysql.conf
    - user: root
    - mode: 400
    - template: jinja
    - context:
        secret: {{ salt["credentials.read_secret"](salt_credential) }}

#   -------------------------------------------------------------
#   Provision Salt credentials
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

dbserver_mysql_salt_credentials:
  cmd.script:
    - name: salt://roles/dbserver-mysql/salt/files/dbserver_mysql_salt_credentials.py
    - args: {{ dirs.etc }}/salt/minion.d/mysql
    - onchanges:
        - file: {{ dirs.etc }}/salt/minion.d/mysql
