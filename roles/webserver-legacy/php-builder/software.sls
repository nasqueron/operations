#   -------------------------------------------------------------
#   Salt — Compile custom PHP builds
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2018-10-17
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

#   -------------------------------------------------------------
#   PHP dependencies
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

php_builder_dependencies:
  pkg.installed:
    - pkgs:
      - libmcrypt
