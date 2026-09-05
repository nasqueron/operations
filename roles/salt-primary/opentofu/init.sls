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
      - terraform # fallback for providers not compiled for FreeBSD

      # Helpers for authentication to Terraform providers
      - ovhcloud-cli
