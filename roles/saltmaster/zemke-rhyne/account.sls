#   -------------------------------------------------------------
#   Salt — Provision Docker engine
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2017-04-28
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import dirs with context %}
{% set zr_home = "/home/zr" %}

#   -------------------------------------------------------------
#   Account
#
#   This account is used by Jenkins jobs to deploy artifacts
#   after a build.
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

zr_account:
  user.present:
    - name: zr
    - fullname: Zemke-Rhyne
    - uid: 8900
    - gid: 9002
    - home: {{ zr_home }}
