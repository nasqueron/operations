#   -------------------------------------------------------------
#   Salt — Provision software
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Eglide
#   Created:        2017-02-23
#   Description:    Account to build applications from source code
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import dirs with context %}

#   -------------------------------------------------------------
#   Service account
#   -------------------------------------------------------------

builder_account:
  user.present:
    - name: builder
    - fullname: Software builder account for configure and make
    - createhome: False
    - uid: 831
    - gid: deployment

#   -------------------------------------------------------------
#   Sudo capabilities
#
#   Members of deployment should be able to sudo -u builder …
#   -------------------------------------------------------------

builder_sudo_capabilities_file:
  file.managed:
    - name: {{ dirs.etc }}/sudoers.d/builder
    - source: salt://roles/shellserver/userland-software/files/builder.sudoers
    - template: jinja
