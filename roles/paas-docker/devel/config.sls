#   -------------------------------------------------------------
#   Salt — Docker development
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2022-04-15
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

/etc/systemd/system/docker.socket.d/socket.conf:
  file.managed:
    - source: salt://roles/paas-docker/devel/files/socket.conf
    - mode: 644
    - makedirs: True
