#   -------------------------------------------------------------
#   Salt — RC
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Eglide
#   Created:        2016-06-15
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% set use_zfs = salt['node.has']('zfs:pool') %}

#   -------------------------------------------------------------
#   IPv6
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% if grains['os_family'] == 'Debian' %}
rc:
  file.managed:
    - name : /etc/rc.local
    - source: salt://roles/core/rc/files/rc.local.sh
    - mode: 755
{% endif %}

#   -------------------------------------------------------------
#   Periodic tasks configuration
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% if grains['os'] == 'FreeBSD' %}
/etc/periodic.conf:
  file.managed:
    - source: salt://roles/core/rc/files/periodic.conf
    - template: jinja
    - context:
        use_zfs: {{ use_zfs }}

/etc/locate.rc:
  file.managed:
      - source: salt://roles/core/rc/files/locate.rc
{% endif %}
