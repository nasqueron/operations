#   -------------------------------------------------------------
#   Salt configuration for Nasqueron servers
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   Description:    Table of the services to use in configuration
#   -------------------------------------------------------------

nasqueron_services:
  # Complector services
  salt_primary: 172.27.27.7
  vault: 172.27.27.7
  vault_url: https://172.27.27.7:8200

  # PaaS Docker
  docker:
    api: 172.27.27.5
    cd: 172.27.27.5
    notifications: 172.27.27.5

  # Databases
  db-A: 172.27.27.8
  db-B: 172.27.27.9
