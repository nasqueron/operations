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

{% from "map.jinja" import shells with context %}

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
    - shell: {{ shells[args['shell']|default('bash')] }}
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

{% for group, args in pillar.get('shellgroups', {}).iteritems() %}
group_{{group}}:
  group.present:
    - name: {{group}}
    - system: False
    - gid: {{ args['gid'] }}
    - members: {{ args['members'] }}
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

