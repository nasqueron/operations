#   -------------------------------------------------------------
#   Salt — Deploy ViperServ (eggdrop)
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2017-11-14
#   Description:    Eggdrop on Freenode
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import dirs with context %}

#   -------------------------------------------------------------
#   Service accounts
#   -------------------------------------------------------------

{% for username, user in pillar['viperserv_accounts'].iteritems() %}

viperserv_account_{{ username }}:
  user.present:
    - name: {{ username }}
    - fullname: {{ user['fullname'] }}
    - uid: {{ user['uid'] }}
    - gid: nasqueron-irc
    - home: /var/run/{{ username }}

/var/run/{{ username }}:
  file.directory:
    - user: {{ user['uid'] }}
    - group: nasqueron-irc
    - dir_mode: 700

{% endfor %}

#   -------------------------------------------------------------
#   Sudo capabilities
#
#   Members of nasqueron-irc should be able to sudo -u viperserv …
#   -------------------------------------------------------------

viperserv_sudo_capabilities_file:
  file.managed:
    - name: {{ dirs.etc }}/sudoers.d/viperserv
    - source: salt://roles/viperserv/account/files/viperserv.sudoers
    - template: jinja
    - context:
        accounts: {{ pillar['viperserv_accounts'].keys() }}
        bots: {{ pillar['viperserv_bots'].keys() }}
