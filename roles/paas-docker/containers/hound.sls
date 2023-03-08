#   -------------------------------------------------------------
#   Salt — Provision Docker engine
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% set has_selinux = salt['grains.get']('selinux:enabled', False) %}

#   -------------------------------------------------------------
#   Configuration provider
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/usr/local/bin/hound-generate-config:
  file.managed:
    - source: salt://roles/paas-docker/containers/files/hound/generate-config.py
    - mode: 755


{% for instance, container in pillar['docker_containers']['hound'].items() %}

#   -------------------------------------------------------------
#   Home directory
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/srv/hound/{{ instance }}:
  file.directory:
    - makedirs: True

{% if has_selinux %}
selinux_context_{{ instance }}_data:
  selinux.fcontext_policy_present:
    - name: /srv/hound/{{ instance }}
    - sel_type: container_file_t

selinux_context_{{ instance }}_data_applied:
  selinux.fcontext_policy_applied:
    - name: /srv/hound/{{ instance }}
{% endif %}

#   -------------------------------------------------------------
#   Configuration
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% set repos_path = "/srv/hound/" + instance + "/repos.txt" %}
{% set config_path = "/srv/hound/" + instance + "/config.json" %}

hound_{{ instance }}_repositories:
  cmd.run:
    - name: docker run --rm nasqueron/devtools github/list-repositories.py {{ container['github_account'] }} -b > {{ repos_path }}
    - creates: {{ repos_path }}

hound_{{ instance }}_config:
  cmd.run:
    - name: hound-generate-config {{ container['github_account'] }} < {{ repos_path }} > {{ config_path }}
    - creates: {{ config_path }}

#   -------------------------------------------------------------
#   Container
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{{ instance }}:
  docker_container.running:
    - detach: True
    - interactive: True
    - image: ghcr.io/hound-search/hound
    - binds: /srv/hound/{{ instance }}:/data
    - ports:
        - 6080
    - port_bindings:
        - {{ container['app_port'] }}:6080

{% endfor %}
