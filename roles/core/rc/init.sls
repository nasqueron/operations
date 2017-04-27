#   -------------------------------------------------------------
#   Salt — RC
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Eglide
#   Created:        2016-06-15
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

#   -------------------------------------------------------------
#   IPv6
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% if grains['os_family'] == 'Debian' %}
rc:
  file.managed:
    - name : /etc/rc.local
    - source: salt://roles/core/rc/files/rc.local.sh
{% endif %}
