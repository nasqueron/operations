dbserver_postgresql:

  server:
    # Fantoir database needs the pg_trim extension
    with_contrib: True

  users:
    # Password paths are relative to ops/secrets/
    fantoir:
      password: dbserver/cluster-A/users/fantoir
      privileges:
        - database: fantoir
          scope: schema
          privileges:
            - ALL

  databases:
    fantoir:
      encoding: UTF8
      owner: fantoir
      extensions:
        - pg_trgm
