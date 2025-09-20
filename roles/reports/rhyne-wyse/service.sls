#   -------------------------------------------------------------
#   Salt — Nasqueron Reports
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import services with context %}

#   -------------------------------------------------------------
#   Wrapper to call the service
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/usr/local/bin/rhyne-wyse:
  file.managed:
    - source: salt://roles/reports/rhyne-wyse/files/rhyne-wyse.sh
    - mode: 755

#   -------------------------------------------------------------
#   Log
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/usr/local/etc/newsyslog.conf.d/rhyne-wyse.conf:
  file.managed:
    - source: salt://roles/reports/rhyne-wyse/files/syslog/rhyne-wyse.conf

rhyne_wyse_newsyslog_run:
  cmd.run:
    - name: newsyslog -NC
    - creates: /var/log/rhyne-wyse.log

#   -------------------------------------------------------------
#   Cron
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/usr/local/etc/cron.d/rhyne-wyse:
  file.managed:
    - source: salt://roles/reports/rhyne-wyse/files/rhyne-wyse.cron
    - makedirs: True
