#   -------------------------------------------------------------
#   Salt — Provision Docker engine
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2018-10-30
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% set has_selinux = salt['grains.get']('selinux:enabled', False) %}
{% set containers = pillar['docker_containers'][grains['id']] %}

{% for instance, container in containers['redis'].items() %}
{% set image = salt['paas_docker.get_image']("library/redis", container) %}

#   -------------------------------------------------------------
#   Data directory
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/srv/redis/{{ instance }}:
  file.directory:
    - user: 999
    - group: 999
    - makedirs: True

{% if has_selinux %}
selinux_context_{{ instance }}_redis_data:
  selinux.fcontext_policy_present:
    - name: /srv/redis/{{ instance }}
    - sel_type: container_file_t

selinux_context_{{ instance }}_redis_data_applied:
  selinux.fcontext_policy_applied:
    - name: /srv/redis/{{ instance }}
{% endif %}

#   -------------------------------------------------------------
#   Container
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{{ instance }}:
  docker_container.running:
    - detach: True
    - interactive: True
    - image: {{ image }}
    - binds: /srv/redis/{{ instance }}:/data
    - healthcheck:
        Test: redis-cli ping
        Interval: 30000000000
{% if 'network' in container %}
    - networks:
      - {{ container['network'] }}
{% endif %}
{% endfor %}

#   -------------------------------------------------------------
#   Host preparation
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

vm.overcommit_memory:
  sysctl.present:
    - value: 1
