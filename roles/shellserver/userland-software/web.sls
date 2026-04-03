#   -------------------------------------------------------------
#   Salt — Provision web software
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Eglide
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import dirs with context %}

#   -------------------------------------------------------------
#   Web utilities
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

web_utilities:
  pkg.installed:
    - pkgs:
      - igal2

{{ dirs.bin }}/html-directories:
  file.managed:
    - source: salt://roles/shellserver/userland-software/files/html-directories.sh
    - mode: 755
