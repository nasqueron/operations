dbserver_postgresql:

  server:
    cluster: A

    # Fantoir database needs the pg_trgm extension
    with_contrib: True

    listen_addresses: "*"

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

  # Network connections allowed in pg_hba.conf
  connections:
    - db: airflow
      user: airflow
      ips: 172.27.27.0/28

    - db: fantoir
      user: fantoir
      ips: 172.27.27.0/28
