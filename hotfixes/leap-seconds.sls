#   -------------------------------------------------------------
#   Salt — Hotfixes to mitigate bugs and security issues
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

#   -------------------------------------------------------------
#   Leap seconds for NTP
#
#   Known issue - https://bugs.ntp.org/show_bug.cgi?id=3898
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% if grains['os'] == 'FreeBSD' %}

/var/db/ntpd.leap-seconds.list:
  file.managed:
    - source: https://data.iana.org/time-zones/tzdb/leap-seconds.list
    - skip_verify: True
    - mode: 644

{% endif %}
