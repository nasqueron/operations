#   -------------------------------------------------------------
#   Salt — Kernel state
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2017-11-06
#   License:        Trivial work, not eligible to copyright
#
#   -------------------------------------------------------------

{% if grains['os'] == 'FreeBSD' %}

/etc/sysctl.conf:
  file.managed:
    - source: salt://roles/core/sysctl/files/sysctl.conf

{% endif %}
