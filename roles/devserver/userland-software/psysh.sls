#   -------------------------------------------------------------
#   Salt — Provision dev software
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2017-11-03
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import dirs with context %}

#   -------------------------------------------------------------
#   Prepare for installation
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/usr/local/share/psysh:
  file.directory:
    - dir_mode: 755

#   -------------------------------------------------------------
#   Fetch software and PHP manual
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

psysh_software:
  archive.extracted:
    - name: /opt/psysh
    - enforce_toplevel: False
    - source: https://github.com/bobthecow/psysh/releases/download/v0.11.15/psysh-v0.11.15.tar.gz
    - source_hash: 93306871291df3bbd26403c76c4e43f6be571799695b6bd7a512dacf3feaf3af

/usr/local/share/psysh/php_manual.sqlite:
  file.managed:
    - source: https://psysh.org/manual/en/php_manual.sqlite
    - skip_verify: True
    - require:
      - file: /usr/local/share/psysh

#   -------------------------------------------------------------
#   Install binary
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

psysh_permissions:
  file.managed:
    - name: /opt/psysh/psysh
    - mode: 755
    - replace: False
    - require:
      - archive: psysh_software

{{ dirs.bin }}/psysh:
  file.symlink:
    - target: /opt/psysh/psysh
    - require:
      - file: psysh_permissions
