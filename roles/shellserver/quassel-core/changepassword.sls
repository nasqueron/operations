#   -------------------------------------------------------------
#   Salt — Provision Quassel core
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Eglide
#   Created:        2018-03-28
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import dirs with context %}
{% from "roles/shellserver/quassel-core/map.jinja" import quassel with context %}

#   -------------------------------------------------------------
#   Wrapper for quasselcore --change-userpass
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{{ dirs.bin }}/chquasselpasswd:
  file.managed:
    - source: salt://roles/shellserver/quassel-core/files/chquasselpasswd.sh.jinja
    - mode: 755
    - template: jinja
    - context:
        quassel: {{ quassel }}

#   -------------------------------------------------------------
#   Sudo capabilities
#
#   Quassel users can change their password
#   -------------------------------------------------------------

chquasselpasswd_sudo_capabilities_file:
  file.managed:
    - name: {{ dirs.etc }}/sudoers.d/chquasselpasswd
    - source: salt://roles/shellserver/quassel-core/files/chquasselpasswd.suoders
    - template: jinja
    - context:
        dirs: {{ dirs }}
        quassel: {{ quassel }}
        users: {{ pillar['quassel_users'] }}
