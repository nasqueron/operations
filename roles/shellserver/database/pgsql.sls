#   -------------------------------------------------------------
#   Salt — Provision PostgreSQL
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Eglide
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import packages with context %}

#   -------------------------------------------------------------
#   Software
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

postgresql:
  pkg.installed:
    - pkgs:
      - {{ packages.postgresql }}
