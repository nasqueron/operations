#   -------------------------------------------------------------
#   Salt — Provision a salt primary server
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import dirs, packages_prefixes with context %}

#   -------------------------------------------------------------
#   Additional software
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

install_salt_api_extra_software:
  pkg.installed:
    - pkgs:
      - {{ packages_prefixes.python3 }}cherrypy

#   -------------------------------------------------------------
#   Configuration
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{{ dirs.etc }}/salt/master.d/api.conf:
  file.managed:
    - source: salt://roles/salt-primary/api/files/api.conf
    - template: jinja
    - context:
        certificates_path: {{ dirs.etc }}/certificates/salt-api

#   -------------------------------------------------------------
#   Fix for contextvars issue
#
#   This package is now a part of the Python library since 3.7
#   Yes, this is hacky.
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% set pythonversion = "{}.{}".format(grains["pythonversion"][0], grains["pythonversion"][1]) %}

drop_contextvars:
  file.comment:
     - name: {{ grains["saltpath"] }}-{{ grains["saltversion"] }}-py{{ pythonversion }}.egg-info/requires.txt
     - regex: ^contextvars
     - backup: False
     - ignore_missing: True
