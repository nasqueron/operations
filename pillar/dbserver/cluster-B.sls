dbserver_mysql_aliases:
  hosts:
    - &viperserv 172.27.27.33

dbserver_mysql:

  server:
    salt:
      # Account used by Salt to configure the server
      credentials: dbserver/cluster-B/users/salt

  users:
    # Password paths are relative to ops/secrets

    nasqueron:
      password: dbserver/cluster-B/users/nasqueron
      host: *viperserv
      privileges:
        - database: Nasqueron
          scope: database

  # Tips for databases:
  #   This is a MariaDB cluster. At version 10.6, MariaDB is still using utf8mb3
  #   by default, but we generally prefer utf8mb4 as encoding.
  #
  #   For collation, MySQL 8 uses utf8mb4_0900_ai_ci / utf8mb4_0900_as_cs
  #   It's a accent (in)sensitive case (in)sensitive based on Unicode 9.0.
  #   For MariaDB 10.10+, we can use uca1400_as_ci, that's Unicode 14.0.
  #
  #   TRANSITION NOTE. On MariaDB 10.6, utf8mb4_unicode_520_ci is the "newest".
  #   From 2023-04-15, we starting to use uca1400_as_ci as default collation.

  databases:
    # Database used by IRC eggdrops
    Nasqueron: &unicode
      encoding: utf8mb4
      collation: uca1400_as_ci