#   -------------------------------------------------------------
#   Salt — Webserver content
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

#   -------------------------------------------------------------
#   .env
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% for env_path, env_args in pillar.get("webserver_content_dotenv", {}).items() %}

{{ env_path }}:
  file.managed:
    - source: salt://roles/webserver-content/_generic/files/dot.env
    - mode: 400
    - user: {{ env_args["user"] }}
    - show_changes: False
    - template: jinja
    - context:
        environment:
          {% for db in env_args.get("databases", {}) %}
          {% set prefix = db.get("prefix", "") %}
          {{ prefix }}DB_HOST: {{ pillar["nasqueron_services"][db["service"]] }}
          {{ prefix }}DB_USER: {{ salt["credentials.get_username"](db["credentials"]) }}
          {{ prefix }}DB_PASSWORD: {{ salt["credentials.get_password"](db["credentials"]) }}
          {% endfor %}

          {% if "vault" in env_args %}
          VAULT_ROLE_ID: {{ salt["credentials.get_username"](env_args["vault"]) }}
          VAULT_SECRET_ID: {{ salt["credentials.get_password"](env_args["vault"]) }}
          {% endif %}

          {% for key, value in env_args.get("extra_values", {}).items() %}
          {{ key }}: {{ value }}
          {% endfor %}

          {% for key, vault_path in env_args.get("extra_credentials", {}).items() %}
          {{ key }}: {{ salt["credentials.get_password"](vault_path) }}
          {% endfor %}
{% endfor %}
