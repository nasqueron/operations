#   -------------------------------------------------------------
#   Salt — Provision a salt primary server
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2018-10-04
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import dirs, packages_prefixes with context %}

#   -------------------------------------------------------------
#   Additional software
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

install_salt_primary_extra_software:
  pkg.installed:
    - pkgs:
      # Jenkins execution module
      - {{ packages_prefixes.python3 }}python-jenkins
      # For staging-commit-message
      - {{ packages_prefixes.python3 }}gitpython
      # Pillar
      - {{ packages_prefixes.python3 }}salt-tower
      # For Vault helper scripts
      - {{ packages_prefixes.python3 }}hvac

{{ dirs.bin }}/staging-commit-message:
  file.managed:
    - source: salt://roles/salt-primary/software/files/staging-commit-message.py
    - mode: 755

{{ dirs.bin }}/autochmod-git:
  file.managed:
    - source: salt://roles/salt-primary/software/files/autochmod-git.sh
    - mode: 755
