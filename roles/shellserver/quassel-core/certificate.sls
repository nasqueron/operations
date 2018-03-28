#   -------------------------------------------------------------
#   Salt — Provision Quassel core
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Eglide
#   Created:        2018-03-28
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

#   -------------------------------------------------------------
#   Certificate
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/var/lib/quassel:
  file.directory:
    - user: quassel
    - group: quassel

quassel_certificate:
  cmd.run:
    - name: cat privkey.pem cert.pem > /var/lib/quassel/quasselCert.pem
    - cwd: /etc/letsencrypt/live/quassel.eglide.org
    - creates: /var/lib/quassel/quasselCert.pem

quassel_certificate_rights:
  file.managed:
    - name: /var/lib/quassel/quasselCert.pem
    - replace: False
    - user: quassel
    - group: quassel
    - mode: 400
