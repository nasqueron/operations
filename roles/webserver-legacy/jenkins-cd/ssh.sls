#   -------------------------------------------------------------
#   Salt — Sites to provision on the legacy web server
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

#   -------------------------------------------------------------
#   SSH access for Jenkins
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/var/run/deploy/.ssh:
  file.directory:
    - user: deploy
    - group: deploy
    - dir_mode: 700 

/var/run/deploy/.ssh/authorized_keys:
  file.managed:
    - source: salt://roles/webserver-legacy/jenkins-cd/files/authorized_keys
    - user: deploy
    - group: deploy
    - mode: 600
