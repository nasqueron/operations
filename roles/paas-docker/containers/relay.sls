#   -------------------------------------------------------------
#   Salt — Provision Docker engine
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% set has_selinux = salt['grains.get']('selinux:enabled', False) %}

{% for instance, container in pillar['docker_containers']['relay'].items() %}

#   -------------------------------------------------------------
#   Data directory
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/srv/relay/{{ instance }}:
  file.directory:
    - makedirs: True

/srv/relay/{{ instance }}/config.yml:
  file.managed:
    - source: salt://roles/paas-docker/containers/files/relay/config.yml.jinja
    - mode: 644
    - template: jinja
    - context:
        container: {{ container }}

relay_{{ instance }}_credentials:
  docker_container.run:
    - image: getsentry/relay:nightly
    - command: bash -c "relay credentials generate --stdout > /work/.relay/credentials.json"
    - binds:
      - /srv/relay/{{ instance }}:/work/.relay
    - replace: True
    - creates: /srv/relay/{{ instance }}/credentials.json

{% if has_selinux %}
selinux_context_{{ instance }}_relay_data:
  selinux.fcontext_policy_present:
    - name: /srv/relay/{{ instance }}
    - sel_type: container_file_t

selinux_context_{{ instance }}_relay_data_applied:
  selinux.fcontext_policy_applied:
    - name: /srv/relay/{{ instance }}
{% endif %}

#   -------------------------------------------------------------
#   Container
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{{ instance }}:
  docker_container.running:
    - detach: True
    - interactive: True
    - image: getsentry/relay:nightly
    - binds:
      - /srv/relay/{{ instance }}:/work/.relay
      - /srv/geoip:/usr/local/share/geoip:ro
    - ports:
      - 3000
    - port_bindings:
      - {{ container['app_port'] }}:3000
    - networks:
      - {{ container['network'] }}

{% endfor %}
