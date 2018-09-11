#   -------------------------------------------------------------
#   Salt — Provision Docker engine
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2018-06-18
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% set has_selinux = salt['grains.get']('selinux:enabled', False) %}
{% set containers = pillar['docker_containers'][grains['id']] %}

#   -------------------------------------------------------------
#   Storage directory
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/srv/openfire:
  file.directory:
    - user: 999
    - group: 999
    - makedirs: True

{% if has_selinux %}
selinux_context_openfire_data:
  selinux.fcontext_policy_present:
    - name: /srv/openfire
    - sel_type: svirt_sandbox_file_t

selinux_context_openfire_data_applied:
  selinux.fcontext_policy_applied:
    - name: /srv/openfire
{% endif %}

#   -------------------------------------------------------------
#   Container
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

openfire:
  docker_container.running:
    - detach: True
    - interactive: True
    - image: gizmotronic/openfire
    - binds: /srv/openfire:/var/lib/openfire
    - hostname: {{ containers['openfire']['host'] }}
    - ports: {{ pillar['xmpp_ports'] }}
    - port_bindings:
{% for port in pillar['xmpp_ports'] %}
      - {{ containers['openfire']['ip'] }}:{{ port }}:{{ port }}
{% endfor %}
