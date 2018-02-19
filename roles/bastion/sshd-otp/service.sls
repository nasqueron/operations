#   -------------------------------------------------------------
#   Salt — Bastion
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Description:    This role allows to login through alternative
#                   ways, like traditional keys or with an OTP.
#   Created:        2018-02-19
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import dirs, paths, services with context %}

#   -------------------------------------------------------------
#   Service
#
#   :: FreeBSD / rc
#   :: *       / systemd
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% if grains['os'] == 'FreeBSD' %}

sshd_otp_service:
  file.managed:
    - name: {{ dirs.etc }}/rc.d/sshd-otp
    - source: salt://roles/bastion/sshd-otp/files/sshd.rc
    - mode: 755

sshd_otp_service_enable:
  file.managed:
    - name: /etc/rc.conf.d/sshd_otp
    - source: salt://roles/bastion/sshd-otp/files/sshd.rc.conf

sshd_otp_running:
  service.running:
    - name: sshd-otp
    - watch:
      - file: sshd_otp_service

{% elif services['manager'] == 'systemd' %}

sshd_otp_service:
  file.managed:
    - name: {{ dirs.etc }}/systemd/system/sshd-otp.service
    - source: salt://roles/bastion/sshd-otp/files/sshd.service
    - mode: 755
    - template: jinja
    - context:
        executable: {{ paths.sshd }}-otp

sshd_otp_running:
  service.running:
    - name: sshd-otp
    - enable: true
    - watch:
      - file: sshd_otp_service

{% endif %}
