#   -------------------------------------------------------------
#   Salt — postfix Configuration
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

postfix_config:
  db:
    service: db-a
    database: mail
    credential: dbserver/cluster-A/users/postfix

  discard_mailboxes:

    # Phabricator likes to send mail to its own no-reply address (T2349)
    - notifications-noreply@devcentral.nasqueron.org
