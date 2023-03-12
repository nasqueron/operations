#   -------------------------------------------------------------
#   Salt — Provision Docker engine
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   Notes:          Environment follows getsentry/self-hosted
#   -------------------------------------------------------------

{% set has_selinux = salt['grains.get']('selinux:enabled', False) %}

{% for instance, container in pillar['docker_containers']['symbolicator'].items() %}

#   -------------------------------------------------------------
#   Data directory
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% for subdir in ['data', 'etc'] %}
/srv/symbolicator/{{ instance }}/{{ subdir }}:
  file.directory:
    - makedirs: True
    - user: 10021
    - group: 10021
{% endfor %}

/srv/symbolicator/{{ instance }}/etc/config.yml:
  file.managed:
    - source: salt://roles/paas-docker/containers/files/symbolicator/config.yml
    - user: 10021
    - group: 10021

{% if has_selinux %}
selinux_context_{{ instance }}_symbolicator_data:
  selinux.fcontext_policy_present:
    - name: /srv/symbolicator/{{ instance }}
    - sel_type: container_file_t

selinux_context_{{ instance }}_symbolicator_data_applied:
  selinux.fcontext_policy_applied:
    - name: /srv/symbolicator/{{ instance }}
{% endif %}

#   -------------------------------------------------------------
#   Container
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{{ instance }}:
  docker_container.running:
    - detach: True
    - interactive: True
    - image: getsentry/symbolicator:nightly
    - command: run -c /etc/symbolicator/config.yml
    - binds:
      - /srv/symbolicator/{{ instance }}/data:/data
      - /srv/symbolicator/{{ instance }}/etc:/etc/symbolicator:ro
    - networks:
      - {{ container["network"] }}

{% endfor %}
