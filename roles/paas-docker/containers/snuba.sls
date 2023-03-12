#   -------------------------------------------------------------
#   Salt — Provision Docker engine
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   Notes:          Environment follows getsentry/self-hosted
#   -------------------------------------------------------------

{% for instance, container in pillar['docker_containers']['snuba'].items() %}
{% set is_api = container.get("api", False) %}

#   -------------------------------------------------------------
#   Container
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{{ instance }}:
  docker_container.running:
    - detach: True
    - interactive: True
    - image: getsentry/snuba:nightly
    {% if "command" in container %}
    - command: {{ container["command"] }}
    {% endif %}
    - environment:
        SNUBA_SETTINGS: docker
        CLICKHOUSE_HOST: {{ container["services"]["clickhouse"] }}
        DEFAULT_BROKERS: {{ container["services"]["broker"] }}
        REDIS_HOST: {{ container["services"]["redis"] }}
        UWSGI_MAX_REQUESTS: 10000
        UWSGI_DISABLE_LOGGING: "true"

        # Leaving the value empty to just pass whatever is set
        # on the host system (or in the .env file)
        SENTRY_EVENT_RETENTION_DAYS:
    - networks:
      - {{ container["network"] }}

#   -------------------------------------------------------------
#   Bootstrap / migration
#
#   docker exec doesn't follow the entrypoint, so full command
#   is needed.
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% if is_api %}
Boostrap and migrate Snuba - {{ instance }}:
  cmd.run:
    - name: |
        docker exec {{ instance }} snuba bootstrap --no-migrate --force
        docker exec {{ instance }} snuba migrations migrate --force
{% endif %}

{% endfor %}
