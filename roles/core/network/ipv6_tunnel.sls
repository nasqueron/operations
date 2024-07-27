#   -------------------------------------------------------------
#   Salt — Network
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import dirs, services with context %}

#   -------------------------------------------------------------
#   4to6 tunnel
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% if salt['node.has']('network:ipv6_tunnel') %}

network_ipv6:
  file.managed:
    - name : {{ dirs.sbin }}/ipv6-setup-tunnel
    - source: salt://roles/core/network/files/ipv6-tunnels/{{ grains['id'] }}.sh.jinja
    - template: jinja
    - mode: 755

{% if services['manager'] == 'systemd' %}
/etc/systemd/system/ipv6-tunnel.service:
  file.managed:
    - source: salt://roles/core/network/files/ipv6-tunnels/ipv6-tunnel.service
    - mode: 755
  service.running:
    - name: ipv6-tunnel
    - enable: true
{% endif %}


{% endif %}
