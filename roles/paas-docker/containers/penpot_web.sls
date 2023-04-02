#   -------------------------------------------------------------
#   Salt — Provision Penpot
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% set has_selinux = salt["grains.get"]("selinux:enabled", False) %}
{% set containers = pillar["docker_containers"] %}

{% for instance, container in containers["penpot_web"].items() %}

{% set flags = salt["convert.to_flags"](container["features"]) %}

#   -------------------------------------------------------------
#   Storage directory
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/srv/{{ container["realm"] }}/assets:
  file.directory:
    - makedirs: True
    - user: 1001
    - group: 1001

{% if has_selinux %}
selinux_context_penpot_data:
  selinux.fcontext_policy_present:
    - name: /srv/{{ container["realm"] }}/assets
    - sel_type: container_file_t

selinux_context_penpot_data_applied:
  selinux.fcontext_policy_applied:
    - name: /srv/{{ container["realm"] }}/assets
{% endif %}

#   -------------------------------------------------------------
#   Front-end assets
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/srv/{{ container["realm"] }}/public:
  file.directory:
    - makedirs: True

penpot_{{ container["realm"] }}_public_content:
  cmd.run:
    - name: |
        wget https://artifacts.nasqueron.org/penpot/penpot.tar.gz && \
        tar xzf penpot.tar.gz --strip 1 && \
        rm penpot.tar.gz
    - cwd: /srv/{{ container["realm"] }}/public
    - creates: /srv/{{ container["realm"] }}/public/version.txt

/srv/{{ container["realm"] }}/public/js/config.js:
  file.managed:
    - mode: 444
    - contents: |
        var penpotFlags = "{{ flags }}";

{% if has_selinux %}
selinux_context_penpot_public_data:
  selinux.fcontext_policy_present:
    - name: /srv/{{ container["realm"] }}/public
    - sel_type: container_file_t

selinux_context_penpot_public_data_applied:
  selinux.fcontext_policy_applied:
    - name: /srv/{{ container["realm"] }}/public
{% endif %}

#   -------------------------------------------------------------
#   Container
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{{ instance }}:
  docker_container.running:
    - detach: True
    - interactive: True
    - image: penpotapp/backend
    - networks:
      - {{ container["network"] }}
    - binds: /srv/{{ container["realm"] }}/assets:/opt/data/assets
    - environment:
        PENPOT_FLAGS: {{ flags }}
        PENPOT_SECRET_KEY: {{ salt["credentials.get_password"](container["credentials"]["secret_key"]) }}

        PENPOT_PREPL_HOST: 0.0.0.0
        PENPOT_PUBLIC_URI: https://{{ container["host"] }}

        PENPOT_DATABASE_URI: postgresql://{{ container["services"]["postgresql"] }}/penpot
        PENPOT_DATABASE_USERNAME: {{ salt["credentials.get_username"](container["credentials"]["postgresql"]) }}
        PENPOT_DATABASE_PASSWORD: {{ salt["credentials.get_password"](container["credentials"]["postgresql"]) }}

        PENPOT_REDIS_URI: redis://{{ container["services"]["redis"] }}/0

        PENPOT_ASSETS_STORAGE_BACKEND: assets-fs
        PENPOT_STORAGE_ASSETS_FS_DIRECTORY: /opt/data/assets

        # Our privacy policy explicitly states we don't transfer data
        # to third parties.
        PENPOT_TELEMETRY_ENABLED: "false"

        {% if "smtp" in container["features"] %}
        PENPOT_SMTP_HOST: {{ container["services"]["smtp"] }}
        PENPOT_SMTP_PORT: 25
        PENPOT_SMTP_TLS: "false"
        {% endif %}
        PENPOT_SMTP_DEFAULT_FROM: no-reply@{{ container["host"] }}
        PENPOT_SMTP_DEFAULT_REPLY_TO: no-reply@{{ container["host"] }}

        {% if "login-with-github" in container["features"] %}
        PENPOT_GITHUB_CLIENT_ID: {{ salt["credentials.get_username"](container["credentials"]["github"]) }}
        PENPOT_GITHUB_CLIENT_SECRET: {{ salt["credentials.get_password"](container["credentials"]["github"]) }}
        {% endif %}
    - ports:
        - 6060
    - port_bindings:
        - {{ container['app_port'] }}:6060

{% endfor %}
