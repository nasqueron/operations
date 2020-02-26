#   -------------------------------------------------------------
#   Salt — Deploy Bonjour chaton
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Created:        2017-01-24
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import dirs with context %}

#   -------------------------------------------------------------
#   Service account
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

bonjour_chaton_account:
  user.present:
    - name: chaton
    - fullname: Bonjour chaton bot
    - uid: 832
    - gid: 827
    - home: /opt/bonjour-chaton

#   -------------------------------------------------------------
#   Sudo capabilities
#
#   Members of bonjour-chaton-dev should be able to sudo -u bonjour_chaton …
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

bonjour_chaton_sudo_capabilities_file:
  file.managed:
    - name: {{ dirs.etc }}/sudoers.d/bonjour_chaton
    - source: salt://roles/shellserver/bonjour-chaton/files/bonjour_chaton.sudoers
    - template: jinja
