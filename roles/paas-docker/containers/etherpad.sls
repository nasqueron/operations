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
    - image: nasqueron/etherpad
    - links: {{ container['mysql_link'] }}:mysql
    - binds: /srv/{{ instance }}/var:/opt/etherpad-lite/var
    - ports:
      - 9001
    - port_bindings:
      - {{ container['app_port'] }}:9001

pad_deploy_api:
  cmd.run:
    - creates: /srv/{{ instance }}/.ok-apikey
    - name: |
        docker cp /srv/{{ instance }}/var/APIKEY.txt {{ instance }}:opt/etherpad-lite/APIKEY.txt
        docker restart {{ instance }}
        touch /srv/{{ instance }}/.ok-apikey

pad_deploy_plugins:
  cmd.run:
    - creates: /srv/{{ instance }}/.ok-plugins
    - name: |
  {% for plugin in container['plugins'] %}
        docker exec {{ instance }} npm install {{  plugin }}
  {% endfor %}
        docker restart {{ instance }}
        touch /srv/{{ instance }}/.ok-plugins

{%  endfor %}
