#   -------------------------------------------------------------
#   Salt — Deploy ViperServ (eggdrop)
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2017-11-14
#   Description:    Eggdrop on Libera
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import dirs with context %}

#   -------------------------------------------------------------
#   Service accounts
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% for username, user in pillar['viperserv_accounts'].items() %}

viperserv_account_{{ username }}:
  user.present:
    - name: {{ username }}
    - fullname: {{ user['fullname'] }}
    - uid: {{ user['uid'] }}
    - gid: nasqueron-irc
    - home: {{ dirs.share }}/{{ username }}

/var/run/{{ username }}:
  file.directory:
    - user: {{ user['uid'] }}
    - group: nasqueron-irc
    - dir_mode: 711

{{ dirs.share }}/{{ username }}/.gitconfig:
  file.managed:
    - source: salt://roles/viperserv/account/files/dot.gitconfig
    - mode: 444

{% endfor %}

#   -------------------------------------------------------------
#   Sudo capabilities
#
#   Members of nasqueron-irc should be able to sudo -u viperserv …
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

viperserv_sudo_capabilities_file:
  file.managed:
    - name: {{ dirs.etc }}/sudoers.d/viperserv
    - source: salt://roles/viperserv/account/files/viperserv.sudoers
    - template: jinja
    - context:
        accounts: {{ pillar['viperserv_accounts'] }}
        bots: {{ pillar['viperserv_bots'] }}
