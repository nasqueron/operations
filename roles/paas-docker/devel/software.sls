#   -------------------------------------------------------------
#   Salt — Docker development tools
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2020-02-15
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import dirs, packages_prefixes with context %}

#   -------------------------------------------------------------
#   Dependencies not required in production but useful in dev
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

docker_development_utilities:
  pkg.installed:
    - pkgs:
      - git
      - jq
      - {{ packages_prefixes.python3 }}pip
      # From Nasqueron repo
      - dive
  pip.installed:
    - name: docker-compose
    - require:
      - pkg: docker_development_utilities

#   -------------------------------------------------------------
#   Tools
#
#   :: Arcanist
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{{ dirs.bin }}/arc:
  file.managed:
    - source: salt://roles/paas-docker/devel/files/arc.sh
    - mode: 755

{{ dirs.bin }}/psysh:
  file.managed:
    - source: salt://roles/paas-docker/devel/files/psysh.sh
    - mode: 755
