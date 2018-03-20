#   -------------------------------------------------------------
#   Salt — Provision dev software
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2018-03-20
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import dirs with context %}

#   -------------------------------------------------------------
#   Install phar and symlink to bin
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/opt/wp-cli:
  file.directory

/opt/wp-cli/wp-cli.phar:
  file.managed:
    - source: https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    - skip_verify: True
    - mode: 755

{{ dirs.bin }}/wp:
  file.symlink:
    - target: /opt/wp-cli/wp-cli.phar
    - require:
      - file: /opt/wp-cli/wp-cli.phar
