#   -------------------------------------------------------------
#   Salt — OpenSSH configuration
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2017-02-28
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

/etc/ssh/sshd_config:
  file.managed:
    - source: salt://roles/core/sshd/files/sshd_config
