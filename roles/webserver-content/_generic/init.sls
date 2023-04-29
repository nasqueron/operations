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

{% set db_credentials = env_args["db"]["credentials"] %}

{{ env_path }}:
  file.managed:
    - source: salt://roles/webserver-content/_generic/files/dot.env
    - mode: 400
    - show_changes: False
    - template: jinja
    - context:
        environment:
          {% if "db" in env_args %}
          DB_HOST: {{ pillar["nasqueron_services"][env_args["db"]["service"]] }}
          DB_USER: {{ salt["credentials.get_username"](db_credentials) }}
          DB_PASSWORD: {{ salt["credentials.get_password"](db_credentials) }}
          {% endif %}

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
