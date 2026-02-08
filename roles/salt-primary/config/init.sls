#   -------------------------------------------------------------
#   Salt — Salt configuration
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import dirs with context %}

#   -------------------------------------------------------------
#   Providers
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{{ dirs.etc }}/salt/master.d/pillar-tower.conf:
  file.managed:
    - source: salt://roles/salt-primary/config/files/pillar-tower.conf
    - file_mode: 644

#   -------------------------------------------------------------
#   Log
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/var/log/deploy.log:
  file.managed:
    - source: ~       # Empty file, not managed by Salt
    - replace: False
    - user: root
    - group: ops
    - mode: 664
