#   -------------------------------------------------------------
#   Salt — Provision users accounts
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Eglide
#   Created:        2016-04-08
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
#   :: Managed SSH keys
#
#   -------------------------------------------------------------

#   -------------------------------------------------------------
#   Disabled accounts
#   -------------------------------------------------------------

{% for user in pillar.get('revokedusers') %}
{{user}}:
  user.absent
{% endfor %}

#   -------------------------------------------------------------
#   Active accounts
#   -------------------------------------------------------------

{% for user, args in pillar.get('shellusers', {}).iteritems() %}
{{user}}:
  user.present:
    - fullname: {{ args['fullname'] }}
    - shell: {{ args['shell']|default('/bin/bash') }}
    - uid: {{ args['uid'] }}
{% endfor %}

#   -------------------------------------------------------------
#   Groups
#   -------------------------------------------------------------

shell:
  group.present:
    - system: True
    - gid: 200
    - members:
{% for user, args in pillar.get('shellusers', {}).iteritems() %}
      - {{user}}
{% endfor %}

{% if salt['group.info']('root') and salt['group.info']('root')['gid'] == 0 %}
rename_root_group_to_wheel:
  cmd.run:
    - name: sed -i 's/root:x:0:/wheel:x:0:/' /etc/group
{% endif %}

wheel:
  group.present:
    - system: True
    - gid: 0
    - members:
{% for user in pillar.get('shelladmins') %}
      - {{user}}
{% endfor %}

    
#   -------------------------------------------------------------
#   Managed SSH keys
#   -------------------------------------------------------------

{% for user, args in pillar.get('shellusers', {}).iteritems() %}
sshkey_{{user}}:
  ssh_auth.present:
    - user: {{user}}
    - source: salt://roles/shellserver/users/files/ssh_keys/{{user}}
{% endfor %}

