#   -------------------------------------------------------------
#   Salt — Provision software
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Eglide
#   Description:    Account to build applications from source code
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import dirs with context %}
{% set uids = pillar["uids"] %}
{% set gids = pillar["gids"] %}

#   -------------------------------------------------------------
#   Service account
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

builder_account:
  user.present:
    - name: builder
    - fullname: Software builder account for configure and make
    - uid: {{ uids["builder"] }}
    - gid: {{ gids["deployment"] }}
    - home: /var/run/builder

#   -------------------------------------------------------------
#   Sudo capabilities
#
#   Members of deployment should be able to sudo -u builder …
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

builder_sudo_capabilities_file:
  file.managed:
    - name: {{ dirs.etc }}/sudoers.d/builder
    - source: salt://roles/builder/account/files/builder.sudoers
    - template: jinja
