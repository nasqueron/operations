dbserver_postgresql:

  server:
    # Fantoir database needs the pg_trgm extension
    with_contrib: True

  users:
    # Password paths are relative to ops/secrets/

    airflow:
      password: dbserver/cluster-A/users/airflow
      privileges:
        - database: airflow
          scope: schema
          privileges:
            - ALL

    fantoir:
      password: dbserver/cluster-A/users/fantoir
      privileges:
        - database: fantoir
          scope: schema
          privileges:
            - ALL

  databases:
    airflow:
      encoding: UTF8
      owner: airflow

    fantoir:
      encoding: UTF8
      owner: fantoir
      extensions:
        - pg_trgm
