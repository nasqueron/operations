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
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#
#   :: Disabled accounts
#   :: ZFS (before user account creation)
#   :: Active accounts
#   :: ZFS (after user account creation)
#   :: Groups
#   :: SSH keys
#
#   -------------------------------------------------------------

{% from "map.jinja" import dirs, shells with context %}

{% set users = salt['forest.get_users']() %}
{% set zfs_tank = salt['node.get']("zfs:pool") %}
{% set forest = salt['node.get']['forest'] %}

#   -------------------------------------------------------------
#   Disabled accounts
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% for username in pillar.get('revokedusers') %}
{{ username }}:
  user.absent
{% endfor %}

#   -------------------------------------------------------------
#   ZFS datasets
#
#   Where ZFS is available, home directories are created as separate
#   datasets. That has several benefits, like allowing users to create
#   snapshots or manage backups.
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% if zfs_tank %}
zfs_home_permissions_sets:
  cmd.run:
    - name: |
        zfs allow -s @local allow,clone,create,diff,hold,mount,promote,receive,release,rollback,snapshot,send {{ zfs_tank }}{{ dirs.home }}
        zfs allow -s @descendent allow,clone,create,diff,destroy,hold,mount,promote,receive,release,rename,rollback,snapshot,send {{ zfs_tank }}{{ dirs.home }}
        touch {{ dirs.home }}/.zfs-permissions-set
    - creates: {{ dirs.home }}/.zfs-permissions-set

{% for username in users %}
{% set home_directory = zfs_tank + dirs['home'] + '/' + username %}

{{ home_directory }}:
  zfs.filesystem_present

zfs_permissions_home_local_{{ username }}:
  cmd.run:
    - name: zfs allow -lu {{ username }} @local {{ home_directory }}
    - require:
        - user: {{ username }}
    - onchanges:
        - zfs: {{ home_directory }}

zfs_permissions_home_descendant_{{ username }}:
  cmd.run:
    - name: zfs allow -du {{ username }} @descendent {{ home_directory }}
    - require:
        - user: {{ username }}
    - onchanges:
        - zfs: {{ home_directory }}

/home/{{ username }}:
  file.directory:
    - user: {{ username }}
    - group: {{ username }}
    - dir_mode: 700
    - require:
        - user: {{ username }}

{% endfor %}
{% endif %}

#   -------------------------------------------------------------
#   Active accounts
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% for username, user in users.items() %}
{{ username }}:
  user.present:
    - fullname: {{ user['fullname'] }}
    - shell: {{ shells[user['shell']|default('bash')] }}
    - uid: {{ user['uid'] }}
    - loginclass: {{ user['class']|default('english') }}
{% endfor %}

#   -------------------------------------------------------------
#   Groups
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% for groupname, group in salt['forest.get_groups']().items() %}
group_{{ groupname }}:
  group.present:
    - name: {{ groupname }}
    - gid: {{ group['gid'] }}
    - members: {{ group['members'] }}
{% endfor %}

#   -------------------------------------------------------------
#   SSH keys
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% for username, user in users.items() %}

/home/{{ username }}/.ssh:
  file.directory:
    - user: {{ username }}
    - group: {{ username }}
    - dir_mode: 700

/home/{{ username }}/.ssh/authorized_keys:
  file.managed:
    - source: salt://roles/core/users/files/authorized_keys
    - user: {{ username }}
    - group: {{ username }}
    - mode: 600
    - template: jinja
    - context:
        keys: {{ user['ssh_keys']|default([]) }}
        keys_forest: {{ user['ssh_key_by_forests'][forest]|default([]) }}

{% endfor %}
