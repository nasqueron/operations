#   -------------------------------------------------------------
#   Salt — Provision users accounts
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2017-11-09
#   Description:    Adds and revokes user accounts, in the relevant
#                   groups and with their stable SSH keys.
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

#   -------------------------------------------------------------
#   Table of contents
#   -------------------------------------------------------------
#
#   :: Disabled accounts
#   :: Active accounts
#   :: Groups
#   :: SSH keys
#
#   -------------------------------------------------------------

{% from "map.jinja" import shells with context %}

#   -------------------------------------------------------------
#   Disabled accounts
#   -------------------------------------------------------------

{% for username in pillar.get('revokedusers') %}
{{ username }}:
  user.absent
{% endfor %}

#   -------------------------------------------------------------
#   Active accounts
#   -------------------------------------------------------------

{% for username, user in salt['forest.get_users']().iteritems() %}
{{ username }}:
  user.present:
    - fullname: {{ user['fullname'] }}
    - shell: {{ shells[user['shell']|default('bash')] }}
    - uid: {{ user['uid'] }}
{% endfor %}

#   -------------------------------------------------------------
#   Groups
#   -------------------------------------------------------------

{% for groupname, group in salt['forest.get_groups']().iteritems() %}
group_{{ groupname }}:
  group.present:
    - name: {{ groupname }}
    - gid: {{ group['gid'] }}
    - members: {{ group['members'] }}
{% endfor %}

#   -------------------------------------------------------------
#   SSH keys
#   -------------------------------------------------------------

{% for username, user in salt['forest.get_users']().iteritems() %}

/home/{{ username }}/.ssh:
  file.directory:
    - user: {{ username }}
    - group: {{ username }}
    - dir_mode: 700

/home/{{ username}}/.ssh/authorized_keys:
  file.managed:
    - source: salt://roles/core/users/files/authorized_keys
    - user: {{ username }}
    - group: {{ username }}
    - mode: 600
    - template: jinja
    - context:
        keys: {{ user['ssh_keys']|default([]) }}

{% endfor %}
