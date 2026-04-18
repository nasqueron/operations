#   -------------------------------------------------------------
#   Salt — Provision dev software
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
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
    - source: https://github.com/bobthecow/psysh/releases/download/v0.12.22/psysh-v0.12.22.tar.gz
    - source_hash: d990dadada3badaf3a5fbed3fc1275e2c39519bc62f2c5b3287d12e88130583a

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
