#   -------------------------------------------------------------
#   Salt — Provision Docker engine
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2018-06-18
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% set has_selinux = salt['grains.get']('selinux:enabled', False) %}
{% set containers = pillar['docker_containers'][grains['id']] %}

{% for instance, container in containers['etherpad'].items() %}

#   -------------------------------------------------------------
#   Storage directory
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/srv/{{ instance }}:
  file.directory:
    - makedirs: True

{% if has_selinux %}
selinux_context_{{ instance }}_data:
  selinux.fcontext_policy_present:
    - name: /srv/{{ instance }}
    - sel_type: svirt_sandbox_file_t

selinux_context_{{ instance }}_data_applied:
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
    - image: nasqueron/etherpad:production
    - links: {{ container['mysql_link'] }}:mysql
    - binds: /srv/{{ instance }}/var:/opt/etherpad-lite/var
    - ports:
      - 9001
    - port_bindings:
      - {{ container['app_port'] }}:9001

#   -------------------------------------------------------------
#   API key
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% set api_key_path = "/srv/" + instance + "/APIKEY.txt" %}

{{ api_key_path }}:
  file.managed:
    - mode: 400
    - contents: {{ salt['zr.get_password'](container['credential']) }}

deploy_api_key_{{ instance }}:
  cmd.run:
    - name: |
        docker cp {{ api_key_path }} {{ instance }}:opt/etherpad-lite/APIKEY.txt
        docker restart {{ instance }}
    - onchanges:
        - docker_container: {{ instance }}
        - file: {{ api_key_path }}

{%  endfor %}
