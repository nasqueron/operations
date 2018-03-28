#   -------------------------------------------------------------
#   Salt — Provision Quassel core
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Eglide
#   Created:        2018-03-28
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import shells with context %}

#   -------------------------------------------------------------
#   Account
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

quassel_account:
  group.present:
    - name: quassel
    - gid: 990
    - system: True
  user.present:
    - name: quassel
    - fullname: Quassel core
    - uid: 990
    - gid: 990
    - home: /var/lib/quassel
    - shell: {{ shells.nologin }}
