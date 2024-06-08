#   -------------------------------------------------------------
#   Salt — ViMbAdmin Configuration
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

vimbadmin_config:
  db:
    service: db-A
    database: mail
    credential: dbserver/cluster-A/users/mailManagement
  security: mailserver/security
