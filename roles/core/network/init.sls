#   -------------------------------------------------------------
#   Salt — Network
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2016-06-15
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

#   -------------------------------------------------------------
#   IPv6
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% if grains['os_family'] == 'Debian' %}
network_ipv6:
  file.managed:
    - name : /usr/sbin/ipv6-setup-tunnel
    - source: salt://roles/core/network/files/{{ grains['id'] }}_ipv6.sh.jinja
    - template: jinja
    - mode: 755
{% endif %}
