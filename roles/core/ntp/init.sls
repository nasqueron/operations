#   -------------------------------------------------------------
#   Salt — NTP
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% if grains["os_family"] == "RedHat" %}
chrony:
  pkg.installed

/etc/chrony.conf:
  file.managed:
    - source: salt://roles/core/ntp/files/chrony.conf.jinja
    - template: jinja
    - context:
        servers: {{ salt["pillar.get"]("ntp_servers") }}
    - user: root
    - group: root
    - mode: 644
    - watch_in:
      - service: chrony_service

chrony_service:
  service.running:
    - name: chronyd
    - enable: true
{% endif %}

{% if grains["os"] == "FreeBSD" %}
/etc/rc.conf.d/ntpd:
  file.managed:
    - source: salt://roles/core/ntp/files/rc/ntpd.conf

/etc/ntp.conf:
  file.managed:
    - source: salt://roles/core/ntp/files/ntp.conf.jinja
    - template: jinja
    - context:
        servers: {{ salt["pillar.get"]("ntp_servers") }}
    - watch_in:
      - service: ntpd

ntpd:
  service.running:
    - enable: True
{% endif %}
