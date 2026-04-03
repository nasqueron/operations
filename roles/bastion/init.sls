#   -------------------------------------------------------------
#   Salt — Bastion
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Description:    This role allows to login through alternative
#                   ways, like traditional keys or with an OTP.
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

include:
  - .sshd-otp
  - .yubico
