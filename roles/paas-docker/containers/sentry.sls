#   -------------------------------------------------------------
#   Salt — Provision Docker engine
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2016-12-15
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% set has_selinux = salt['grains.get']('selinux:enabled', False) %}
{% set containers = pillar['docker_containers'][grains['id']] %}

#   -------------------------------------------------------------
#   Data directory
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% for realm, args in pillar['sentry_realms'].items() %}

/srv/sentry/{{ realm }}:
  file.directory:
    - user: 999
    - group: 999
    - makedirs: True

/srv/sentry/{{ realm }}/bin/sentry:
  file.managed:
    - source: salt://roles/paas-docker/containers/files/sentry/sentry.sh.jinja
    - template: jinja
    - mode: 755
    - makedirs: True
    - context:
        links: {{ args['links'] }}
        credential_key: args['credential']

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

{% for instance, container in containers['sentry'].items() %}

{% set args = pillar['sentry_realms'][container['realm']] %}

{{ instance }}:
  docker_container.running:
    - detach: True
    - interactive: True
    - image: library/sentry
    - binds: &binds /srv/sentry/{{ container['realm'] }}:/var/lib/sentry/files
    - links: &links
        - {{ args['links']['postgresql'] }}:postgres
        - {{ args['links']['redis'] }}:redis
        - {{ args['links']['smtp'] }}:smtp
    - environment: &env
        - SENTRY_SECRET_KEY: {{ salt['zr.get_token'](args['credential']) }}
        - SENTRY_FILESTORE_DIR:
        - SENTRY_USE_SSL: 1
        - SENTRY_SERVER_EMAIL: {{ args['email_from'] }}
        - SENTRY_FILESTORE_DIR: /var/lib/sentry/files
    - ports:
      - 80
    - port_bindings:
      - {{ container['app_port'] }}:9000

{% endfor %}

#   -------------------------------------------------------------
#   Services containers
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% for service in ['worker', 'cron'] %}
{% for instance, container in containers['sentry_' + service].items() %}

{% set args = pillar['sentry_realms'][container['realm']] %}

{{ instance }}:
  docker_container.running:
    - detach: True
    - interactive: True
    - image: library/sentry
    - binds: *binds
    - links: *links
    - environment: *env
    - command: run {{ service }}

{% endfor %}
{% endfor %}
