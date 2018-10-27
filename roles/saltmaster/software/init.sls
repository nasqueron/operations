#   -------------------------------------------------------------
#   Salt — Provision a salt master
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2018-10-04
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import packages_prefixes with context %}

#   -------------------------------------------------------------
#   Additional software
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

install_salt_extra_software:
  pkg.installed:
    - pkgs:
      # Jenkins execution module
      - {{ packages_prefixes.python3 }}python-jenkins
