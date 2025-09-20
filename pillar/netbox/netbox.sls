#   -------------------------------------------------------------
#   Salt — NetBox configuration
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

netbox:
  app_port: 17000
  db:
    host: localhost
    name: netbox
    credential: dbserver/windriver-pgsql/users/netbox
  secret_key: nasqueron/netbox/key
