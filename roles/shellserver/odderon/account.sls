#   -------------------------------------------------------------
#   Salt — Deploy Odderon (darkbot)
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Description:    Darkbot
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import dirs with context %}
{% set uids = pillar["uids"] %}
{% set gids = pillar["gids"] %}

#   -------------------------------------------------------------
#   Service account
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

odderon_account:
  user.present:
    - name: odderon
    - fullname: Odderon
    - uid: {{ uids["odderon"] }}
    - gid: {{ gids["nasqueron-irc"] }}
    - home: /opt/odderon

#   -------------------------------------------------------------
#   Sudo capabilities
#
#   Members of nasqueron-irc should be able to sudo -u odderon …
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

odderon_sudo_capabilities_file:
  file.managed:
    - name: {{ dirs.etc }}/sudoers.d/odderon
    - source: salt://roles/shellserver/odderon/files/odderon.sudoers
    - template: jinja
