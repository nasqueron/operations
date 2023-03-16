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
