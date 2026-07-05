#   -------------------------------------------------------------
#   Database configuration for devserver
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

#   -------------------------------------------------------------
#   MySQL (MariaDB)
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

x-mariadb-encodings:
  unicode: &unicode
    encoding: utf8mb4
    collation: utf8mb4_uca1400_as_ci

dbserver_mysql:

  server:
    salt:
      # Account used by Salt to configure the server
      credentials: dbserver/windriver-mariadb/users/salt

  # As of 2026-04, users and databases are mostly managed manually.
  # You're more than welcome to automate any user/db deployment here.
  # cluster-B.sls can be helpful for syntax hints
  users:

    ###
    ### Zed / HyperShip
    ###

    zed:
      password: dbserver/windriver-mariadb/users/zed
      host: localhost
      privileges:
        - database: zed
          scope: database

  databases:
    zed: *unicode

#   -------------------------------------------------------------
#   PostgreSQL
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

dbserver_postgresql:

  server:
    cluster: windriver
    version: 18

    # Fantoir database needs the pg_trgm extension
    with_contrib: True

    listen_addresses: "127.0.0.1"

  # As of 2024-09, users and databases are managed manually.
  # You're more than welcome to automate any user/db deployment here.
  # cluster-A.sls can be helpful for syntax hints
  users:
    keruald:
      password: dbserver/windriver-pgsql/users/keruald
      privileges:
       - database: test_keruald_db
         scope: schema
         privileges:
           - ALL

    netbox:
      password: dbserver/windriver-pgsql/users/netbox
      privileges:
       - database: netbox
         scope: schema
         privileges:
           - ALL

  databases:
    netbox:
      encoding: UTF8
      owner: netbox

    test_keruald_db:
      encoding: UTF8
      owner: keruald

  connections:
    - db: netbox
      user: netbox
      ips: 127.0.0.1/32
      method: password

    - db: test_keruald_db
      user: keruald
      ips: 127.0.0.1/32
      method: password
