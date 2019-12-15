#   -------------------------------------------------------------
#   Salt — Network
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2016-06-15
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import dirs with context %}

{% set network = salt['node.get']('network') %}

#   -------------------------------------------------------------
#   IPv4
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% if grains['os'] == 'FreeBSD' %}
/etc/rc.conf.d/netif/ipv4_{{ network['ipv4_interface'] }}:
  file.managed:
    - source: salt://roles/core/network/files/netif.rc
    - makedirs: True
    - template: jinja
    - context:
        interface: {{ network['ipv4_interface'] }}
        ipv4_address: {{ network['ipv4_address'] }}
        ipv4_netmask: {{ network['ipv4_netmask'] | default('255.255.255.0') }}
        ipv4_aliases: {{ salt['node.get_list']('network:ipv4_aliases') }}
        dhcp_required: {{ salt['node.has']('network:dhcp_required') }}
        ipv6_interface: {{ network['ipv6_interface'] }}
        has_native_ipv6: {{ salt['node.has']('network:ipv6_native') }}

/etc/rc.conf.d/routing:
  file.managed:
    - source: salt://roles/core/network/files/routing.rc
    - template: jinja
    - context:
        ipv4_gateway: {{ network['ipv4_gateway'] }}
        ipv6_gateway: {{ network['ipv6_gateway'] | default('') }}
{% endif %}

#   -------------------------------------------------------------
#   IPv6
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% if salt['node.has']('network:ipv6_tunnel') %}
network_ipv6:
  file.managed:
    - name : {{ dirs.sbin }}/ipv6-setup-tunnel
    - source: salt://roles/core/network/files/{{ grains['id'] }}_ipv6.sh.jinja
    - template: jinja
    - mode: 755
{% endif %}
