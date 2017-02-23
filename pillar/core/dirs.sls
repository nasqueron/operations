#   -------------------------------------------------------------
#   Salt — Canonical directories
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2017-01-23
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

dirs:
  {% if grains['os_family'] == 'FreeBSD' %}
  etc: /usr/local/etc
  bin: /usr/local/bin
  include: /usr/local/include
  lib: /usr/local/lib
  {% elif grains['kernel'] == 'Linux' %}
  etc: /etc
  bin: /usr/bin
  include: /usr/include
  lib: /usr/lib
  {% endif %}
