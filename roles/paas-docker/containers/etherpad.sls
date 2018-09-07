#   -------------------------------------------------------------
#   Salt — Provision Docker engine
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2018-06-18
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% set has_selinux = salt['grains.get']('selinux:enabled', False) %}
{% set containers = pillar['docker_containers'][grains['id']] %}
{% set container = containers['etherpad'] %}
{% set instance = 'pad' %}

#   -------------------------------------------------------------
#   Storage directory
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/srv/etherpad:
  file.directory:
    - makedirs: True

{% if has_selinux %}
selinux_context_etherpad_data:
  selinux.fcontext_policy_present:
    - name: /srv/etherpad
    - sel_type: svirt_sandbox_file_t

selinux_context_etherpad_data_applied:
  selinux.fcontext_policy_applied:
    - name: /srv/etherpad
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
    - binds: /srv/etherpad/var:/opt/etherpad-lite/var
    - ports:
      - {{ container['app_port'] }}
    - port_bindings:
      - {{ container['app_port'] }}:9001

pad_deploy_api:
  cmd.run:
    - creates: /srv/etherpad/.ok-apikey
    - name: |
        docker cp /srv/etherpad/var/APIKEY.txt {{ instance }}:opt/etherpad-lite/APIKEY.txt
        docker restart {{ instance }}
        touch /srv/etherpad/.ok-apikey

pad_deploy_plugins:
  cmd.run:
    - creates: /srv/etherpad/.ok-plugins
    - name: |
  {% for plugin in container['plugins'] %}
        docker exec {{ instance }} npm install {{  plugin }}
  {% endfor %}
        docker restart {{ instance }}
        touch /srv/etherpad/.ok-plugins
