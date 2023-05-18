#   -------------------------------------------------------------
#   Salt — Provision Docker engine
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2018-06-18
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% set has_selinux = salt['grains.get']('selinux:enabled', False) %}

{% for instance, container in pillar['docker_containers']['etherpad'].items() %}

#   -------------------------------------------------------------
#   Storage directory
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/srv/{{ instance }}:
  file.directory:
    - user: 9001
    - makedirs: True

{% if has_selinux %}
selinux_context_{{ instance }}_data:
  selinux.fcontext_policy_present:
    - name: /srv/{{ instance }}
    - sel_type: container_file_t

selinux_context_{{ instance }}_data_applied:
  selinux.fcontext_policy_applied:
    - name: /srv/{{ instance }}
{% endif %}

#   -------------------------------------------------------------
#   Configuration file
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% set settings = pillar["etherpad_settings"][instance] %}

/srv/{{ instance }}/var/settings.json:
  file.managed:
    - source: salt://roles/paas-docker/containers/files/etherpad/settings.json.jinja
    - mode: 400
    - user: 9001
    - show_changes: False
    - template: jinja
    - context:
        settings: {{ settings }}
        mysql:
          user: {{ salt["credentials.get_username"](settings["mysql"]["credential"]) }}
          password: {{ salt["credentials.get_password"](settings["mysql"]["credential"]) }}
        users:
          {% for user, user_args in settings.get("users", {}).items() %}
          {{ user }}:
            password: {{ salt["credentials.get_password"](user_args["credential"]) }}
            is_admin: {{ user_args["is_admin"] }}
          {% endfor %}

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
    - user: 9001
    - show_changes: False
    - contents: {{ salt['credentials.get_token'](container['credential']) }}

deploy_api_key_{{ instance }}:
  cmd.run:
    - name: |
        docker cp {{ api_key_path }} {{ instance }}:opt/etherpad-lite/APIKEY.txt
        docker restart {{ instance }}
    - onchanges:
        - docker_container: {{ instance }}
        - file: {{ api_key_path }}

{%  endfor %}
