#   -------------------------------------------------------------
#   Salt — Core — pf
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

/etc/rc.conf.d/pf:
  file.managed:
    - source: salt://roles/core/pf/files/rc/pf.conf

/etc/rc.conf.d/pflog:
  file.managed:
    - source: salt://roles/core/pf/files/rc/pflog.conf

pf:
  service.running

pflog:
  service.running
