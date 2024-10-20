#   -------------------------------------------------------------
#   Salt — Core units
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

include:
  - .rc
  - .certificates
  - .hostname
  - .login
  - .network
  - .memory
  - .monitoring
  - .motd
  - .ntp
  - .pf
  - .src
  - .rsyslog
  - .salt
  - .sshd
  - .sudo
  - .storage
  - .sysctl
  - .timezone
  - .userland-software
  - .users

  # Depends of users or groups
  - .deploy
  - .userland-home
