#   -------------------------------------------------------------
#   Salt — Deploy Odderon (darkbot)
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2017-01-25
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import utilities with context %}

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
  cmd.script:
    - source: salt://roles/shellserver/odderon/files/build.sh.jinja
    - args: "--with-sleep=0 --with-add=0 --with-del=0 --with-random=0"
    - template: jinja
    - context:
        gmake: {{ utilities.gmake }}
    - cwd: /opt/darkbot
    - runas: odderon
    - onchanges:
        - git: darkbot_repo
    - unless: test -f /opt/odderon/LOCKED
