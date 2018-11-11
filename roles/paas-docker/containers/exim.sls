#   -------------------------------------------------------------
#   Salt — Provision Docker engine
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2018-11-10
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% set has_selinux = salt['grains.get']('selinux:enabled', False) %}
{% set containers = pillar['docker_containers'][grains['id']] %}

{% for instance, container in containers['exim'].items() %}
{% set image = salt['paas_docker.get_image']("tianon/exim4", container) %}

#   -------------------------------------------------------------
#   Data directory
#
#   Only required if you provide some hostname to the SMTP server
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% if 'host' in container %}

/srv/exim/{{ instance }}:
  file.directory:
    - user: 999
    - group: 999
    - makedirs: True

/srv/exim/{{ instance }}/mailname:
  file.managed:
    - contents: {{ container['mailname'] }}

{% if has_selinux %}

selinux_context_{{ instance }}_exim_data:
  selinux.fcontext_policy_present:
    - name: /srv/exim/{{ instance }}
    - sel_type: container_file_t

selinux_context_{{ instance }}_exim_data_applied:
  selinux.fcontext_policy_applied:
    - name: /srv/exim/{{ instance }}

{% endif %}

{% endif %}

#   -------------------------------------------------------------
#   Container
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{{ instance }}:
  docker_container.running:
    - detach: True
    - interactive: True
    - image: {{ image }}

{% if 'host' in container %}
    - binds: /srv/exim/{{ instance }}/mailname:/etc/mailname:ro
    - hostname: container['mailname']
{% endif %}

{% if 'network' in container %}
    - networks:
      - {{ container['network'] }}
{% endif %}

{% endfor %}
