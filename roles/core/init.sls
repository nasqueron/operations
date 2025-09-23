#   -------------------------------------------------------------
#   Salt — Core units
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

include:
  - .rc
  - .hostname
  - .login
  - .network
  - .memory
  - .monitoring
  - .motd
  - .ntp
  - .pf
  - .rsyslog
  - .salt
  - .sshd
  - .sudo
  - .storage
  - .sysctl
  - .timezone
  - .userland-software
  - .users

  # Depends on users or groups
  - .certificates
  - .deploy
  - .userland-home

  # Depends on software (git)
  - .src
