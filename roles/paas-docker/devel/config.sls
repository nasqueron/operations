#   -------------------------------------------------------------
#   Salt — Docker development
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

/etc/systemd/system/docker.socket.d/socket.conf:
  file.managed:
    - source: salt://roles/paas-docker/devel/files/socket.conf
    - mode: 644
    - makedirs: True
