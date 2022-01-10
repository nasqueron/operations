#   -------------------------------------------------------------
#   Salt — Provision Docker engine
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2018-03-27
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% set has_selinux = salt['grains.get']('selinux:enabled', False) %}
{% set containers = pillar['docker_containers'][grains['id']] %}

{% for instance, container in containers['mysql'].items() %}
{% set image = salt['paas_docker.get_image']("nasqueron/mysql", container) %}

#   -------------------------------------------------------------
#   Home directory
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/srv/{{ instance }}/mysql:
  file.directory:
    - user: 999
    - group: 999
    - makedirs: True

{% if has_selinux %}
selinux_context_{{ instance }}_mysql_data:
  selinux.fcontext_policy_present:
    - name: /srv/{{ instance }}/mysql
    - sel_type: container_file_t

selinux_context_{{ instance }}_mysql_data_applied:
  selinux.fcontext_policy_applied:
    - name: /srv/{{ instance }}/mysql
{% endif %}

#   -------------------------------------------------------------
#   Container
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{{ instance }}:
  docker_container.running:
    - detach: True
    - interactive: True
    - image: {{ image }}
    - binds: /srv/{{ instance }}/mysql:/var/lib/mysql
    - environment:
        MYSQL_ROOT_PASSWORD: {{ salt['random.get_str'](31) }}
{% if 'network' in container %}
    - networks:
      - {{ container['network'] }}
{% endif %}
    - cap_add:
      - SYS_NICE          # T1672
{% endfor %}
