#   -------------------------------------------------------------
#   Salt — Provision Docker engine
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   Service:        Airfllow
#   -------------------------------------------------------------

docker_images:
  - apache/airflow:2.5.2
  - redis

airflow_default_container_args: &airflow
  realm: nasqueron
  network: airflow

docker_containers:
  redis:
    airflow_redis: *airflow

  airflow:
    airflow_web:
      <<: *airflow
      command: webserver
      command_port: 8080
      app_port: 46080

    airflow_scheduler:
      <<: *airflow
      command: scheduler

    airflow_worker:
      <<: *airflow
      command: celery worker

    airflow_triggerer:
      <<: *airflow
      command: triggerer

    airflow_flower:
      <<: *airflow
      command: celery flower
      command_port: 5555
      app_port: 46555

docker_networks:
  airflow:
    subnet: 172.18.4.0/24

airflow_realms:
  nasqueron:
    network: airflow
    services:
      redis: airflow_redis
      postgresql: 172.27.27.8 # db-A-001.nasqueron.drake
    credentials:
      admin_account: nasqueron/airflow/admin_account
      fernet_key: nasqueron/airflow/fernet
      postgresql: dbserver/cluster-A/users/airflow

#   -------------------------------------------------------------
#   Airflow specific monitorng
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

docker_containers_monitoring:
  check_by_container_name:
    airflow:
      check_http_200:
        airflow_web: /health
        airflow_scheduler: /health
        airflow_flower: /
