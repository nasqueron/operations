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

install_salt_extra_software:
  pkg.installed:
    - pkgs:
      # Jenkins execution module
      - {{ packages_prefixes.python3 }}python-jenkins
      # For staging-commit-message
      - {{ packages_prefixes.python3 }}GitPython

{{ dirs.bin }}/staging-commit-message:
  file.managed:
    - source: salt://roles/salt-primary/software/files/staging-commit-message.py
    - mode: 755
