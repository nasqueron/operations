#   -------------------------------------------------------------
#   Salt — Dovecot Configuration
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

dovecot_config:
  db:
    service: db-a
    database: mail
    credential: dbserver/cluster-A/users/dovecot
