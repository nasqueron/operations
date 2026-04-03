#   -------------------------------------------------------------
#   Salt — Bastion - Yubikeys
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import packages with context %}

#   -------------------------------------------------------------
#   Install PAM module package
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

yubico_pam_software:
  pkg.installed:
    - pkgs:
      - {{ packages['yubico-pam'] }}
