#   -------------------------------------------------------------
#   Salt — Provision Docker engine
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2021-07-30
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% set has_selinux = salt['grains.get']('selinux:enabled', False) %}
{% set containers = pillar['docker_containers'][grains['id']] %}

{% for instance, container in containers['hauk'].items() %}

#   -------------------------------------------------------------
#   Storage directory
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/srv/hauk/{{ instance }}:
  file.directory:
    - user: 9001
    - makedirs: True

/srv/hauk/{{ instance }}/config.php:
  file.managed:
    - source: salt:///roles/paas-docker/containers/files/hauk/config.php.jinja
    - template: jinja
    - mode: 644
    - context:
        url: https://{{ container['host'] }}{{ container['api_entry_point'] }}/

{% if has_selinux %}
selinux_context_{{ instance }}_data:
  selinux.fcontext_policy_present:
    - name: /srv/hauk/{{ instance }}
    - sel_type: container_file_t

selinux_context_{{ instance }}_data_applied:
  selinux.fcontext_policy_applied:
    - name: /srv/hauk/{{ instance }}
{% endif %}

#   -------------------------------------------------------------
#   Container
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{{ instance }}:
  docker_container.running:
    - detach: True
    - interactive: True
    - image: bilde2910/hauk
    - binds: /srv/hauk/{{ instance }}:/etc/hauk
    - ports:
      - 80
    - port_bindings:
      - {{ container['app_port'] }}:80

{%  endfor %}
