#   -------------------------------------------------------------
#   Salt — Provision a salt primary server
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

opentofu_software:
  pkg.installed:
    - pkgs:
      - opentofu
      - terraform # fallback for modules not compiled for FreeBSD
