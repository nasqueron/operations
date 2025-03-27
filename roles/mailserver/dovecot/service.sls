#   -------------------------------------------------------------
#   Salt — Provision Dovecot
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

dovecot_running:
  service.running:
    - name: dovecot
    - enable: True
