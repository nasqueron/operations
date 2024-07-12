#   -------------------------------------------------------------
#   Salt — Provision mail software
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Eglide
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

#   -------------------------------------------------------------
#   Mail clients
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

mail_clients:
  pkg.installed:
    - pkgs:
      - alpine
      - mutt
      - neomutt
