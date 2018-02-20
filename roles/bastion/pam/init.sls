#   -------------------------------------------------------------
#   Salt — Bastion
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Description:    This role allows to login through alternative
#                   ways, like traditional keys or with an OTP.
#   Created:        2018-02-20
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

#   -------------------------------------------------------------
#   FreeBSD
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% if grains['os'] == 'FreeBSD' %}

/etc/pam.d/sshd-otp:
  file.managed:
    - source: salt://roles/bastion/pam/files/sshd-otp-freebsd

{% endif %}
