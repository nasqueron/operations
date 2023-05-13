#   -------------------------------------------------------------
#   Salt — Webserver wwwroot51 content
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

/opt/salt/security:
  file.directory:
    - user: deploy
    - makedirs: True
    - mode: 700

{% for _, identity in pillar.get("wwwroot51_identities", {}).items() %}

{{ identity["path"] }}:
  file.managed:
    - user: deploy
    - mode: 400
    - source: salt://roles/devserver/webserver-wwwroot51/files/id_private
    - template: jinja
    - context:
        secret: {{ identity["secret"] }}
    - show_changes: False

{{ identity["path"] }}.pub:
  file.managed:
    - user: deploy
    - mode: 444
    - contents: |
        {{ salt["credentials.get_username"](identity["secret"]) }}
    - show_changes: False
{% endfor %}
