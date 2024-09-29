#   -------------------------------------------------------------
#   Database configuration for devserver
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

#   -------------------------------------------------------------
#   MySQL (MariaDB)
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

dbserver_mysql:

  server:
    salt:
      # Account used by Salt to configure the server
      credentials: dbserver/windriver-mariadb/users/salt

  # As of 2024-09, users and databases are managed manually
  # You're most than welcome to automate any user/db deployment here.
  # cluster-B.sls can be helpful for syntax hints
  users: {}
  databases: {}

#   -------------------------------------------------------------
#   PostgreSQL
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

dbserver_postgresql:

  server:
    cluster: windriver

    # Fantoir database needs the pg_trgm extension
    with_contrib: True

    listen_addresses: "*"

  # As of 2024-09, users and databases are managed manually
  # You're most than welcome to automate any user/db deployment here.
  # cluster-A.sls can be helpful for syntax hints
  users:
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

  connections:
    - db: netbox
      user: netbox
      ips: 127.0.0.1
      method: password
