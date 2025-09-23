#   -------------------------------------------------------------
#   Salt — Coordination among mail services
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

#   -------------------------------------------------------------
#   Common group for mail services
#
#   Allows reading common TLS certificates and keys.
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

mail_group:
  group.present:
    - name: mail
    - addusers:
      - dovecot
      - postfix
      - acme
