#   -------------------------------------------------------------
#   Salt — Deploy Odderon (darkbot)
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2017-01-24
#   Description:    Darkbot on Freenode
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

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
    {% if grains['os'] == 'FreeBSD' %}
    - name: /usr/local/etc/sudoers.d/odderon
    {% else %}
    - name: /etc/sudoers.d/odderon
    {% endif %}
    - source: salt://roles/shellserver/odderon/files/odderon.sudoers
