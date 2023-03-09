#   -------------------------------------------------------------
#   Salt — Provision Docker engine
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% set has_selinux = salt['grains.get']('selinux:enabled', False) %}

{% for instance, container in pillar['docker_containers']['kafka'].items() %}
{% set image = salt['paas_docker.get_image']("confluentinc/cp-kafka", container) %}

#   -------------------------------------------------------------
#   Data directory
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/srv/kafka/{{ instance }}:
  file.directory:
    - makedirs: True

{% for subdir in ['data', 'log'] %}
# There are several releases of the cp-kafka instance,
# Some using "appuser", some "cp-kafka" and some "root".
/srv/kafka/{{ instance }}/{{ subdir }}:
  file.directory:
    - user: {{ container["uid"] | default(0) }}
    - group: {{ container["did"] | default(0) }}
{% endfor %}

{% if has_selinux %}
selinux_context_{{ instance }}_kafka_data:
  selinux.fcontext_policy_present:
    - name: /srv/kafka/{{ instance }}
    - sel_type: container_file_t

selinux_context_{{ instance }}_kafka_data_applied:
  selinux.fcontext_policy_applied:
    - name: /srv/kafka/{{ instance }}
{% endif %}

#   -------------------------------------------------------------
#   Container
#
#   Environment is configured per Sentry recommandation
#   Source: https://github.com/getsentry/self-hosted/blob/master/docker-compose.yml
#
#   The secrets volume it to be shared with Zookeeper
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% set loggers = salt["paas_docker.format_env_list"](pillar["kakfa_loggers"]) %}

{{ instance }}:
  docker_container.running:
    - detach: True
    - interactive: True
    - image: {{ image }}
    - binds:
        - /srv/kafka/{{ instance }}/data:/var/lib/kafka/data
        - /srv/kafka/{{ instance }}/log:/var/lib/kafka/log
        - /srv/zookeeper/{{ container["zookeeper"] }}/secrets:/etc/kafka/secrets
    - environment:
        KAFKA_ZOOKEEPER_CONNECT: "{{ container["zookeeper"] }}:2181"
        KAFKA_ADVERTISED_LISTENERS: "PLAINTEXT://{{ instance }}:9092"
        KAFKA_OFFSETS_TOPIC_REPLICATION_FACTOR: "1"
        KAFKA_OFFSETS_TOPIC_NUM_PARTITIONS: "1"
        KAFKA_LOG_RETENTION_HOURS: "24"
        KAFKA_MESSAGE_MAX_BYTES: "50000000" # 50MB or bust
        KAFKA_MAX_REQUEST_SIZE: "50000000" # 50MB on requests apparently too
        CONFLUENT_SUPPORT_METRICS_ENABLE: "false"
        KAFKA_LOG4J_LOGGERS: {{ loggers }}
        KAFKA_LOG4J_ROOT_LOGLEVEL: "WARN"
        KAFKA_TOOLS_LOG4J_LOGLEVEL: "WARN"
    - healthcheck:
        Test: nc -z localhost 9092
        Interval: 30000000000
    - networks:
      - {{ container['network'] }}

#   -------------------------------------------------------------
#   Kafka topics
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% if "topics" in container %}
{{ instance }}_topics:
  cmd.run:
    - name: |
        sleep 20
        {% for topic in container["topics"] %}
        docker exec {{ instance }} kafka-topics --create --topic {{ topic }} --bootstrap-server localhost:9092
        {% endfor %}
        touch /srv/kafka/{{ instance }}/.topics_initialized
    - require:
        - docker_container: {{ instance }}
    - creates: /srv/kafka/{{ instance }}/.topics_initialized
{% endif %}


{% endfor %}
