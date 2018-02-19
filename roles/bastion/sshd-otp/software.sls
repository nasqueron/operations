#   -------------------------------------------------------------
#   Salt — Bastion
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Description:    This role allows to login through alternative
#                   ways, like traditional keys or with an OTP.
#   Created:        2018-02-19
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import paths, capabilities with context %}

#   -------------------------------------------------------------
#   OpenSSH binary symbolic link
#
#   Allows to get 'sshd-otp' in the logs, instead of 'sshd
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{{ paths.sshd }}-otp:
  file.symlink:
    - target: {{ paths.sshd }}

#   -------------------------------------------------------------
#   OpenSSH configuration — OTP
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/etc/ssh/sshd_otp_config:
  file.managed:
    - source: salt://roles/bastion/sshd-otp/files/sshd_config
    - template: jinja
    - context:
        sftp: {{ paths.sftp }}
        print_motd: {{ not capabilities['MOTD-printed-at-login'] }}
