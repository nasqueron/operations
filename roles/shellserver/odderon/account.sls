#   -------------------------------------------------------------
#   Salt — Deploy Odderon (darkbot)
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2017-01-24
#   Description:    Darkbot on Freenode
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import dirs with context %}

#   -------------------------------------------------------------
#   Service account
#   -------------------------------------------------------------

odderon_account:
  user.present:
    - name: odderon
    - fullname: Odderon
    - uid: 830
    - gid: 829
    - home: /opt/odderon

#   -------------------------------------------------------------
#   Sudo capabilities
#
#   Members of nasqueron-irc should be able to sudo -u odderon …
#   -------------------------------------------------------------

odderon_sudo_capabilities_file:
  file.managed:
    - name: {{ dirs.etc }}/sudoers.d/odderon
    - source: salt://roles/shellserver/odderon/files/odderon.sudoers
    - template: jinja
