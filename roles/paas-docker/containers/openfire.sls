#   -------------------------------------------------------------
#   Salt — Provision Docker engine
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2018-06-18
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% set has_selinux = salt['grains.get']('selinux:enabled', False) %}

{% for instance, container in pillar['docker_containers']['openfire'].items() %}

#   -------------------------------------------------------------
#   Storage directory
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/srv/{{ instance }}:
  file.directory:
    - user: 999
    - group: 999
    - makedirs: True

{% if has_selinux %}
selinux_context_openfire_data:
  selinux.fcontext_policy_present:
    - name: /srv/{{ instance }}
    - sel_type: container_file_t

selinux_context_openfire_data_applied:
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
    - image: nasqueron/openfire
    - binds: /srv/{{ instance }}:/var/lib/openfire
    - hostname: {{ container['host'] }}
    - ports: {{ pillar['xmpp_ports'] }}
    - port_bindings:
{% for port in pillar['xmpp_ports'] %}
      - {{ container['ip'] }}:{{ port }}:{{ port }}
{% endfor %}

#   -------------------------------------------------------------
#   Certificate propagation
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/srv/letsencrypt/etc/renewal/{{ container['host'] }}.conf:
  file.append:
    - text:
        - "# Propagate certificates to Openfire container"
        - post-hook = openfire propagate-certificate {{ instance }} {{ container['host'] }}

{% endfor %}
