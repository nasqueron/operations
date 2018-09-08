#   -------------------------------------------------------------
#   Salt — Provision Docker engine
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2018-09-08
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import dirs with context %}

{% set key = dirs['etc'] + "/zr/id_zr" %}

zr_key:
  cmd.run:
    - name: ssh-keygen -N '' -t ed25519 -f {{ key }}
    - creates: {{ key }}
