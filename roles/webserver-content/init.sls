#   -------------------------------------------------------------
#   Salt — Webserver content
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

include:
  {% for state in pillar.get("web_content_sls", []) %}
  - {{ state }}
  {% endfor %}

  - ._generic
