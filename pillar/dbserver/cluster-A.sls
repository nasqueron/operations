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

    mailManagement:
      password: dbserver/cluster-A/users/mailManagement
      privileges:
        - database: mail
          scope: schema
          privileges:
            - ALL

    netbox:
      password: dbserver/cluster-A/users/netbox
      privileges:
        - database: netbox
          scope: schema
          privileges:
            - ALL

    openfire:
      password: dbserver/cluster-A/users/openfire
      privileges:
        - database: openfire
          scope: schema
          privileges:
            - ALL

    orbeon:
      password: dbserver/cluster-A/users/orbeon
      privileges:
        - database: forms
          scope: schema
          privileges:
            - ALL
        - database: forms
          scope: table
          schema: public
          tables:
            - ALL
          privileges:
            - ALL

    postfix:
      password: dbserver/cluster-A/users/postfix
      privileges:
        - database: mail
          scope: table
          schema: public
          tables:
            - ALL
          privileges:
            - SELECT

  databases:
    airflow:
      encoding: UTF8
      owner: airflow

    fantoir:
      encoding: UTF8
      owner: fantoir
      extensions:
        - pg_trgm

    forms:
      encoding: UTF8
      owner: orbeon

    mail:
      encoding: UTF8
      owner: mailManagement

    netbox:
      encoding: UTF8
      owner: netbox

    openfire:
      encoding: UTF8
      owner: openfire

  # Network connections allowed in pg_hba.conf
  connections:
    - db: airflow
      user: airflow
      ips: 172.27.27.0/28

    - db: fantoir
      user: fantoir
      ips: 172.27.27.0/28

    - db: forms
      user: orbeon
      ips: &dwellers 172.27.27.4/32
      method: password

    - db: netbox
      user: netbox
      ips: 172.27.27.0/28

    - db: openfire
      user: openfire
      ips: &docker002 172.27.27.5/32
      method: password

    - db: mail
      user: postfix
      ips: 172.27.27.3/32
      method: password
