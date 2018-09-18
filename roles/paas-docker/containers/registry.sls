#   -------------------------------------------------------------
#   Salt — Provision Docker engine
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2018-09-18
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% set has_selinux = salt['grains.get']('selinux:enabled', False) %}
{% set containers = pillar['docker_containers'][grains['id']] %}

{% for instance, container in containers['registry'].items() %}

#   -------------------------------------------------------------
#   Data directory
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/srv/{{ instance }}:
  file.directory:
    - makedirs: True

{% if has_selinux %}
selinux_context_{{ instance }}:
  selinux.fcontext_policy_present:
    - name: /srv/{{ instance }}
    - sel_type: container_file_t

selinux_context_{{ instance }}_applied:
  selinux.fcontext_policy_applied:
    - name: /srv/{{ instance }}
{% endif %}

#   -------------------------------------------------------------
#   Container
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{{ instance }}:
  docker_container.running:
    - detach: True
    - interactive: True
    - image: library/registry
    - binds: /srv/{{ instance }}:/var/lib/registry
    - ports:
      - 5000
    - port_bindings:
      - {{ container['ip'] }}:{{ container['app_port'] }}:5000 # HTTP

{% endfor %}
