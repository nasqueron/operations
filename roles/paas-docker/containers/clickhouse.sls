#   -------------------------------------------------------------
#   Salt — Provision Docker engine
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% set has_selinux = salt['grains.get']('selinux:enabled', False) %}

{% for instance, container in pillar['docker_containers']['clickhouse'].items() %}
{% set image = salt['paas_docker.get_image']("yandex/clickhouse-server", container) %}

#   -------------------------------------------------------------
#   Data directory
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/srv/clickhouse/{{ instance }}:
  file.directory:
    - makedirs: True

{% for subdir in ['lib', 'log'] %}
/srv/clickhouse/{{ instance }}/{{ subdir }}:
  file.directory:
    - user: 101
    - group: 101
{% endfor %}

/srv/clickhouse/{{ instance }}/{{ container['config'] }}:
  file.managed:
    - source: salt://roles/paas-docker/containers/files/clickhouse/{{ instance }}/{{ container['config'] }}
    - user: 101
    - group: 101

{% if has_selinux %}
selinux_context_{{ instance }}_clickhouse_data:
  selinux.fcontext_policy_present:
    - name: /srv/clickhouse/{{ instance }}
    - sel_type: container_file_t

selinux_context_{{ instance }}_clickhouse_data_applied:
  selinux.fcontext_policy_applied:
    - name: /srv/clickhouse/{{ instance }}
{% endif %}

#   -------------------------------------------------------------
#   Container
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{{ instance }}:
  docker_container.running:
    - detach: True
    - interactive: True
    - image: {{ image }}
    - binds:
        - /srv/clickhouse/{{ instance }}/lib:/var/lib/clickhouse
        - /srv/clickhouse/{{ instance }}/log:/var/log/clickhouse-server
        - /srv/clickhouse/{{ instance }}/{{ container['config'] }}:/etc/clickhouse-server/config.d/{{ container['config'] }}
    - environment:
        # Should be increased if search returns incomplete results
        MAX_MEMORY_USAGE_RATIO: {{ container['max_memory_ratio'] | default(0.3) }}
    - ulimits:
        - nofile=262144:262144
    - healthcheck:
        Test: http_proxy='' wget -nv -t1 --spider 'http://localhost:8123/' || exit 1
        Interval: 30000000000
{% if 'network' in container %}
    - networks:
      - {{ container['network'] }}
{% endif %}
    - cap_add:
      - SYS_NICE
      - NET_ADMIN
      - IPC_LOCK
{% endfor %}
