#   -------------------------------------------------------------
#   Salt — postfix Configuration
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

postfix_config:
  db:
    service: db-A
    database: mail
    credential: dbserver/cluster-A/users/postfix
