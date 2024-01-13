#   -------------------------------------------------------------
#   Salt — Provision Docker engine
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% set has_selinux = salt['grains.get']('selinux:enabled', False) %}


{% for realm, realm_args in pillar['airflow_realms'].items() %}

#   -------------------------------------------------------------
#   Data directory
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

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
#   Airflow configuration for this realm
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% set postgresql_dsn = salt["credentials.get_dsn"](realm_args["services"]["postgresql"], realm_args["credentials"]["postgresql"]) %}

/srv/airflow/{{ realm }}/airflow.cfg:
  file.managed:
    - source: salt://roles/paas-docker/containers/files/airflow/airflow.cfg.jinja
    - mode: 400
    - user: 50000 # As defined in Airflow upstream Docker image
    - template: jinja
    - context:
        realm: {{ realm }}
        vault: {{ realm_args["vault"] }}
        services:
          redis: {{ realm_args["services"]["redis"] }}
        credentials:
          fernet_key: {{ salt["credentials.get_password"](realm_args["credentials"]["fernet_key"]) }}
          db: {{ postgresql_dsn }}/airflow
          sentry: {{ salt["credentials.get_sentry_dsn"](realm_args["sentry"]) }}
          vault: {{ salt["credentials.read_secret"](realm_args["credentials"]["vault"]) }}

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

{{ instance }}:
  docker_container.running:
    - detach: True
    - interactive: True
    - image: nasqueron/airflow
    - command: {{ container["command"] }}
    - binds:
      - /srv/airflow/{{ realm }}/dags:/opt/airflow/dags
      - /srv/airflow/{{ realm }}/logs:/opt/airflow/logs
      - /srv/airflow/{{ realm }}/plugins:/opt/airflow/plugins
      - /srv/airflow/{{ realm }}/airflow.cfg:/opt/airflow/airflow.cfg
    {% if "app_port" in container %}
    - ports:
      - {{ container['command_port'] }}
    - port_bindings:
      - 127.0.0.1:{{ container['app_port'] }}:{{ container['command_port'] }}
    {% endif %}
    - networks:
      - {{ container['network'] }}

{% endfor %}
