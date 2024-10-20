#   -------------------------------------------------------------
#   Salt — Core — pf
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% if grains["os"] == "FreeBSD" or grains["os"] == "OpenBSD" %}

include:
  - .config
  - .services

{% endif %}
