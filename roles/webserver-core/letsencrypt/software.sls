#   -------------------------------------------------------------
#   Salt — Let's encrypt certificates
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2017-04-27
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import dirs, packages with context %}

#   -------------------------------------------------------------
#   Software
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

letsencrypt_software:
  pkg.installed:
    - name: {{ packages.certbot }}

#   -------------------------------------------------------------
#   Working directory
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/var/letsencrypt-auto:
  file.directory:
    - user: root
    - dir_mode: 711

#   -------------------------------------------------------------
#   Configuration file
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{{ dirs.etc }}/letsencrypt/cli.ini:
  file.managed:
    - source: salt://roles/webserver-core/letsencrypt/files/cli.ini
    - makedirs: True

#   -------------------------------------------------------------
#   Extra utilities
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{{ dirs.bin }}/check-letsencrypt-certificates:
  file.managed:
    - source: salt://roles/webserver-core/letsencrypt/files/check-letsencrypt-certificates.py
    - mode: 755
