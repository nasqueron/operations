#   -------------------------------------------------------------
#   Salt — Provision Docker engine
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% set has_selinux = salt['grains.get']('selinux:enabled', False) %}

{% for instance, container in pillar['docker_containers']['zookeeper'].items() %}
{% set image = salt['paas_docker.get_image']("confluentinc/cp-zookeeper", container) %}

#   -------------------------------------------------------------
#   Data directory
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/srv/zookeeper/{{ instance }}:
  file.directory:
    - makedirs: True

{% for subdir in ['data', 'log', 'secrets'] %}
# There are several releases of the cp-zookeeper instance,
# Some using "appuser", some "cp-kafka" and some "root".
/srv/zookeeper/{{ instance }}/{{ subdir }}:
  file.directory:
    - user: {{ container["uid"] | default(0) }}
    - group: {{ container["did"] | default(0) }}
{% endfor %}

{% if has_selinux %}
selinux_context_{{ instance }}_zookeeper_data:
  selinux.fcontext_policy_present:
    - name: /srv/zookeeper/{{ instance }}
    - sel_type: container_file_t

selinux_context_{{ instance }}_zookeeper_data_applied:
  selinux.fcontext_policy_applied:
    - name: /srv/zookeeper/{{ instance }}
{% endif %}

#   -------------------------------------------------------------
#   Container
#
#   Environment is configured per Sentry recommandation
#   Source: https://github.com/getsentry/self-hosted/blob/master/docker-compose.yml
#
#   The secrets volume it to be shared with Zookeeper applications
#   like kafka.
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{{ instance }}:
  docker_container.running:
    - detach: True
    - interactive: True
    - image: {{ image }}
    - binds:
        - /srv/zookeeper/{{ instance }}/data:/var/lib/zookeeper/data
        - /srv/zookeeper/{{ instance }}/log:/var/lib/zookeeper/log
        - /srv/zookeeper/{{ instance }}/secrets:/etc/zookeeper/secrets
    - environment:
        ZOOKEEPER_CLIENT_PORT: "2181"
        CONFLUENT_SUPPORT_METRICS_ENABLE: "false"
        ZOOKEEPER_LOG4J_ROOT_LOGLEVEL: "WARN"
        ZOOKEEPER_TOOLS_LOG4J_LOGLEVEL: "WARN"
        KAFKA_OPTS: "-Dzookeeper.4lw.commands.whitelist=ruok"
    - healthcheck:
        Test: echo "ruok" | nc -w 2 -q 2 localhost 2181 | grep imok
        Interval: 30000000000
{% if 'network' in container %}
    - networks:
      - {{ container['network'] }}
{% endif %}
{% endfor %}
