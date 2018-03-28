#   -------------------------------------------------------------
#   Salt — Provision Quassel core
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Eglide
#   Created:        2018-03-28
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "roles/shellserver/quassel-core/map.jinja" import quassel with context %}

#   -------------------------------------------------------------
#   Certificate
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/var/lib/quassel:
  file.directory:
    - user: {{ quassel.user }}
    - group: {{ quassel.group }}

quassel_certificate:
  cmd.run:
    - name: cat privkey.pem fullchain.pem > /var/lib/quassel/quasselCert.pem
    - cwd: /etc/letsencrypt/live/quassel.eglide.org

quassel_certificate_rights:
  file.managed:
    - name: /var/lib/quassel/quasselCert.pem
    - replace: False
    - user: {{ quassel.user }}
    - group: {{ quassel.group }}
    - mode: 400
