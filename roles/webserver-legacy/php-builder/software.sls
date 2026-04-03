#   -------------------------------------------------------------
#   Salt — Compile custom PHP builds
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

#   -------------------------------------------------------------
#   PHP dependencies
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

php_builder_dependencies:
  pkg.installed:
    - pkgs:
      - libmcrypt
