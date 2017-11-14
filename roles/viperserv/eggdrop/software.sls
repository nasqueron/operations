#   -------------------------------------------------------------
#   Salt — Deploy eggdrop park
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2017-11-05
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import dirs with context %}

#   -------------------------------------------------------------
#   Build eggdrop
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

eggdrop_software:
  file.directory:
    - name: /opt/eggdrop
    - user: builder
    - group: deployment
  cmd.run:
    - name: install-eggdrop
    - runas: builder
    - env:
      - DEST: /opt/eggdrop
    - creates: /opt/eggdrop/eggdrop

{{ dirs.bin }}/eggdrop:
  file.symlink:
    - target: /opt/eggdrop/eggdrop
    - require:
      - cmd: eggdrop_software

#   -------------------------------------------------------------
#   ViperServ directory
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/srv/viperserv:
  file.directory:
    - user: viperserv
    - group: nasqueron-irc
    - dir_mode: 770

viperserv_scripts:
  git.latest:
    - name: https://devcentral.nasqueron.org/source/viperserv.git
    - target: /srv/viperserv/scripts
    - update_head: False
    - user: viperserv
    - require:
      - file: /srv/viperserv
