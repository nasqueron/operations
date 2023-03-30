#   -------------------------------------------------------------
#   Salt — Provision Docker engine
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% set has_selinux = salt['grains.get']('selinux:enabled', False) %}

#   -------------------------------------------------------------
#   Data directory
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% for realm, realm_args in pillar['airflow_realms'].items() %}

/srv/airflow/{{ realm }}:
  file.directory:
    - user: 50000
    - group: 0
    - makedirs: True

{% for subdir in ["dags", "logs", "plugins"] %}
/srv/airflow/{{ realm }}/{{ subdir }}:
  file.directory:
    - user: 50000
    - group: 0
{% endfor %}

/srv/airflow/{{ realm }}/bin/airflow:
  file.managed:
    - source: salt://roles/paas-docker/containers/files/airflow/airflow.sh.jinja
    - makedirs: True
    - mode: 755
    - template: jinja
    - context:
        realm: {{ realm }}
        network: {{ realm_args.network }}
        credentials: {{ realm_args.credentials }}
        services: {{ realm_args.services }}

{% if has_selinux %}
selinux_context_{{ realm }}_airflow_data:
  selinux.fcontext_policy_present:
    - name: /srv/airflow/{{ realm }}
    - sel_type: container_file_t

selinux_context_{{ realm }}_airflow_data_applied:
  selinux.fcontext_policy_applied:
    - name: /srv/airflow/{{ realm }}
{% endif %}

#   -------------------------------------------------------------
#   Service initialization
#
#   The first time Airflow is installed for a realm,
#   it needs to run database migrations.
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

airflow_init_{{ realm }}:
  cmd.run:
    - name: |
        airflow {{ realm }} upgrade
        touch /srv/airflow/{{ realm }}/.initialized
    - environment:
        - _AIRFLOW_WWW_USER: {{ realm_args["credentials"]["admin_account"] }}
    - creates: /srv/airflow/{{ realm }}/.initialized

{% endfor %}

#   -------------------------------------------------------------
#   Containers
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% for instance, container in pillar['docker_containers']['airflow'].items() %}

{% set realm = container["realm"] %}
{% set realm_args = pillar["airflow_realms"][realm] %}

{% set postgresql_dsn = salt["credentials.get_dsn"](realm_args["services"]["postgresql"], realm_args["credentials"]["postgresql"]) %}

{{ instance }}:
  docker_container.running:
    - detach: True
    - interactive: True
    - image: apache/airflow:2.5.2
    - command: {{ container["command"] }}
    - binds:
      - /srv/airflow/{{ realm }}/dags:/opt/airflow/dags
      - /srv/airflow/{{ realm }}/logs:/opt/airflow/logs
      - /srv/airflow/{{ realm }}/plugins:/opt/airflow/plugins
    - environment:
        - AIRFLOW__CORE__EXECUTOR: CeleryExecutor
        - AIRFLOW__CORE__FERNET_KEY: {{ salt["credentials.get_password"](realm_args["credentials"]["fernet_key"]) }}
        - AIRFLOW__CORE__DAGS_ARE_PAUSED_AT_CREATION: "true"
        - AIRFLOW__CORE__LOAD_EXAMPLES: "false"

        - AIRFLOW__API__AUTH_BACKENDS: airflow.api.auth.backend.basic_auth,airflow.api.auth.backend.session

        - AIRFLOW__CELERY__BROKER_URL: redis://:@{{ realm_args["services"]["redis"] }}:6379/0
        - AIRFLOW__CELERY__RESULT_BACKEND: db+postgresql://{{ postgresql_dsn }}/airflow

        - AIRFLOW__DATABASE__SQL_ALCHEMY_CONN: postgresql+psycopg2://{{ postgresql_dsn }}/airflow

        - AIRFLOW__SCHEDULER__ENABLE_HEALTH_CHECK: "true"
    {% if "app_port" in container %}
    - ports:
      - {{ container['command_port'] }}
    - port_bindings:
      - 127.0.0.1:{{ container['app_port'] }}:{{ container['command_port'] }}
    {% endif %}
    - networks:
      - {{ container['network'] }}

{% endfor %}
