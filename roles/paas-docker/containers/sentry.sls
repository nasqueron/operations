#   -------------------------------------------------------------
#   Salt — Provision Docker engine
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2016-12-15
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% set has_selinux = salt['grains.get']('selinux:enabled', False) %}

#   -------------------------------------------------------------
#   Data directory
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% for realm, realm_args in pillar['sentry_realms'].items() %}

/srv/sentry/{{ realm }}:
  file.directory:
    - user: 999
    - group: 999
    - makedirs: True

/srv/sentry/{{ realm }}/data:
  file.directory:
    - user: 999
    - group: 999

/srv/sentry/{{ realm }}/data/files:
  file.directory:
    - user: 999
    - group: 999

/srv/sentry/{{ realm }}/etc:
  file.recurse:
    - source: salt://roles/paas-docker/containers/files/sentry/etc
    - user: 999
    - group: 999
    - dir_mode: 700
    - file_mode: 400
    - template: jinja
    - context:
        realm: {{ realm }}
        args: {{ realm_args }}
        vault:
          approle: {{ salt["credentials.read_secret"](realm_args["credentials"]["vault"]) }}
          addr: {{ pillar["nasqueron_services"]["vault_url"] }}

sentry_{{ realm }}_vault_certificate:
  file.managed:
    - name: /srv/sentry/{{ realm }}/etc/certificates/nasqueron-vault-ca.crt
    - source: salt://roles/core/certificates/files/nasqueron-vault-ca.crt
    - mode: 644
    - makedirs: True

/srv/sentry/{{ realm }}/bin/sentry:
  file.managed:
    - source: salt://roles/paas-docker/containers/files/sentry/sentry.sh.jinja
    - mode: 755
    - template: jinja
    - context:
        realm: {{ realm }}
        network: {{ realm_args["network"] }}

{% if has_selinux %}
selinux_context_{{ realm }}_sentry_data:
  selinux.fcontext_policy_present:
    - name: /srv/sentry/{{ realm }}
    - sel_type: container_file_t

selinux_context_{{ realm }}_sentry_data_applied:
  selinux.fcontext_policy_applied:
    - name: /srv/sentry/{{ realm }}
{% endif %}

{% endfor %}

#   -------------------------------------------------------------
#   Web application
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% for instance, container in pillar['docker_containers']['sentry'].items() %}

{{ instance }}:
  docker_container.running:
    - detach: True
    - interactive: True
    - image: nasqueron/sentry
    - command: {{ container["command"] }}
    - binds:
      - /srv/sentry/{{ container["realm"] }}/etc:/etc/sentry
      - /srv/sentry/{{ container["realm"] }}/data:/data
      - /srv/geoip:/usr/local/share/geoip:ro
    - environment:
        - PYTHONUSERBASE: /data/custom-packages
        - SENTRY_EVENT_RETENTION_DAYS: 90
    {% if "app_port" in container %}
    - ports:
      - 9000
    - port_bindings:
      - {{ container['app_port'] }}:9000
    {% endif %}
    - networks:
      - {{ container['network'] }}

{% endfor %}
