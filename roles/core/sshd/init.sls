#   -------------------------------------------------------------
#   Salt — OpenSSH configuration
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2017-02-28
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import paths, capabilities with context %}

{% set network = salt["node.resolve_network"]() %}

#   -------------------------------------------------------------
#   OpenSSH
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/etc/ssh/sshd_config:
  file.managed:
    - source: salt://roles/core/sshd/files/sshd_config
    - template: jinja
    - context:
        listen_private_address: {{ network["private_ipv4_address"] | default("localhost") }}
        should_listen_to_private_address: {{ network["is_private_network_stable"] | default(false) }}
        sftp: {{ paths.sftp }}
        print_motd: {{ not capabilities['MOTD-printed-at-login'] }}

#   -------------------------------------------------------------
#   Service
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% if grains['os'] == 'FreeBSD' %}
/etc/rc.conf.d/sshd:
  file.managed:
    - source: salt://roles/core/sshd/files/rc.conf
{% endif %}

#   -------------------------------------------------------------
#   PAM
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# T1194 - Debian offers a nologin pam module avoiding people
# to log in when /run/nologin exists. OS can pop this file,
# for example at shutdown time or when systemd boot hasn't
# finished.

pam_disable_nologin:
  file.comment:
    - name: /etc/pam.d/sshd
    - regex: ^account.*pam_nologin\.so
    - backup: None
