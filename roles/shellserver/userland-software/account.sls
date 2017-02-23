#   -------------------------------------------------------------
#   Salt — Provision software
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Eglide
#   Created:        2017-02-23
#   Description:    Account to build applications from source code
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

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
    {% if grains['os'] == 'FreeBSD' %}
    - name: /usr/local/etc/sudoers.d/builder
    {% else %}
    - name: /etc/sudoers.d/builder
    {% endif %}
    - source: salt://roles/shellserver/userland-software/files/builder.sudoers
    - template: jinja
