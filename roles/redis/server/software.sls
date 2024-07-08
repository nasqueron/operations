#   -------------------------------------------------------------
#   Salt — Provision Redis
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

redis_software:
  pkg.installed:
    - pkgs:
        - redis
