#   -------------------------------------------------------------
#   Salt — NTP
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% if grains['os_family'] == 'RedHat' %}
chrony:
  pkg.installed

chrony_service:
  service.running:
    - name: chronyd
    - enable: true
{% endif %}

{% if grains["os"] == "FreeBSD" %}
/etc/rc.conf.d/ntpd:
  file.managed:
    - source: salt://roles/core/ntp/files/rc/ntpd.conf

ntpd:
  service.running:
    - enable: True
{% endif %}
