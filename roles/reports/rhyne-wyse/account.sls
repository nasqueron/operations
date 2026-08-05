#   -------------------------------------------------------------
#   Salt — Nasqueron Reports
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% set uids = pillar["uids"] %}
{% set gids = pillar["gids"] %}

rhyne_wyse_group:
  group.present:
    - name: rhyne-wyse
    - gid: {{ gids["rhyne-wyse"] }}

rhyne_wyse_user:
  user.present:
    - name: rhyne-wyse
    - uid: {{ uids["rhyne-wyse"] }}
    - shell: /bin/sh
    - groups:
        - nasquenautes
    - system: True
    - require:
        - group: rhyne_wyse_group

/var/run/rhyne-wyse:
  file.directory:
    - user: rhyne-wyse
    - group: nasquenautes
    - mode: 770
    - require:
        - user: rhyne_wyse_user
