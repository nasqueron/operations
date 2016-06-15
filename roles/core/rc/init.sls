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

{% if grains['os'] == 'Debian' or grains['os'] == 'Ubuntu' %}
rc:
  file.managed:
    - name : /etc/rc.local
    - source: salt://roles/core/rc/files/rc.local
{% endif %}
