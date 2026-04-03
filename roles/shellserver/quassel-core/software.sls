#   -------------------------------------------------------------
#   Salt — Provision Quassel core
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Eglide
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

#   -------------------------------------------------------------
#   Software
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

quassel-core:
  pkg.installed

#   -------------------------------------------------------------
#   Dependencies
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% if grains['os_family'] == 'Debian' %}
libqt5sql5-psql:
  pkg.installed
{% endif %}
