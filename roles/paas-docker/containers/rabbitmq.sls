#   -------------------------------------------------------------
#   Salt — Provision Docker engine
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2020-09-30
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% set has_selinux = salt['grains.get']('selinux:enabled', False) %}

{% for instance, container in pillar['docker_containers']['rabbitmq'].items() %}

#   -------------------------------------------------------------
#   Storage directory
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/srv/rabbitmq/{{ instance }}/lib:
  file.directory:
    - user: 999
    - group: 999
    - makedirs: True

/srv/rabbitmq/{{ instance }}/lib/.erlang.cookie:
  file.managed:
    - user: 999
    - group: 999
    - mode: 400
    - show_changes: False
    - contents: {{ salt['credentials.get_token'](container['credentials']['erlang_cookie']) }}

{% if has_selinux %}
selinux_context_rabbitmq_data_{{ instance }}:
  selinux.fcontext_policy_present:
    - name: /srv/rabbitmq/{{ instance }}/lib
    - sel_type: container_file_t

selinux_context_rabbitmq_data_applied_{{ instance }}:
  selinux.fcontext_policy_applied:
    - name: /srv/rabbitmq/{{ instance }}/lib
{% endif %}

#   -------------------------------------------------------------
#   Container
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{{ instance }}:
  docker_container.running:
    - detach: True
    - interactive: True
    - image: nasqueron/rabbitmq
    - binds:
        - /srv/rabbitmq/{{ instance }}/lib:/var/lib/rabbitmq
    - hostname: {{ container['host'] }}
    - ports: {{ pillar['rabbitmq_ports'] }}
    - port_bindings:
{% for port in pillar['rabbitmq_ports'] %}
      - {{ container['ip'] }}:{{ port }}:{{ port }}
{% endfor %}


#   -------------------------------------------------------------
#   Credentials
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

rabbitmq_{{ instance }}_root_password:
  cmd.script:
    - source: salt://roles/paas-docker/containers/files/rabbitmq/add_user_root.sh.jinja
    - template: jinja
    - context:
        instance: {{ instance }}
        password: {{ salt['credentials.get_token'](container['credentials']['root']) }}
    - require:
        - {{ instance }}
    - creates: /srv/rabbitmq/{{ instance }}/.auth-configured

{% endfor %}
