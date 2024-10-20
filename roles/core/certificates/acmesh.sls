#   -------------------------------------------------------------
#   Salt - Deploy acme.sh
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

acme.sh:
  pkg.installed

/var/certificates/general:
  file.directory:
    - user: acme
    - mode: 700
    - makedirs: True

/usr/local/etc/newsyslog.conf.d/acme.sh.conf:
  file.managed:
    - source: salt://roles/core/certificates/files/syslog/acme.sh.conf

acmesh_newsyslog_run:
  cmd.run:
    - name: newsyslog -NC
    - creates: /var/log/acme.sh.log

/usr/local/etc/cron.d/acmesh:
  file.managed:
    - source: salt://roles/core/certificates/files/acmesh/acme.sh.cron
    - makedirs: True
