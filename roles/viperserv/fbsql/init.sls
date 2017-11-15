#   -------------------------------------------------------------
#   Salt — Deploy eggdrop park
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2017-11-15
#   License:        Trivial work, not eligible to copyright
#   Data license:   FANTOIR is licensed under Licence Ouverte
#   -------------------------------------------------------------

#   -------------------------------------------------------------
#   Build fbsql
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

fbsql_repo:
  file.directory:
    - name: /opt/fbsql
    - user: builder
    - group: deployment
    - dir_mode: 755
  git.latest:
    - name: https://devcentral.nasqueron.org/source/fbsql.git
    - target: /opt/fbsql
    - user: builder

fbsql_build:
  cmd.run:
    - name: gmake
    - runas: builder
    - cwd: /opt/fbsql
    - creates: /opt/fbsql/fbsql.so

#   -------------------------------------------------------------
#   Install fbsql
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/srv/viperserv/lib/fbsql.so:
  file.symlink:
    - target: /opt/fbsql/fbsql.so
    - user: viperserv
    - group: nasqueron-irc
