#   -------------------------------------------------------------
#   Salt — Deploy Odderon (darkbot)
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2017-01-25
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

darkbot_repo:
  file.directory:
    - name: /opt/darkbot
    - user: odderon
    - group: nasqueron-irc
    - dir_mode: 755
  git.latest:
    - name: https://devcentral.nasqueron.org/source/darkbot.git
    - branch: production
    - target: /opt/darkbot
    - user: odderon
    - unless: test -f /opt/odderon/LOCKED

darkbot_build:
  cmd.run:
    - name: sh build.sh
    - cwd: /opt/darkbot
    - runas: odderon
    - require:
        - git: darkbot_repo
