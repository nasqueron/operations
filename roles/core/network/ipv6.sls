#   -------------------------------------------------------------
#   Salt — Network
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2016-06-15
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

#   -------------------------------------------------------------
#   Table of contents
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#
#   :: Native IPv6
#   :: 4to6 tunnel
#   :: Routes
#
#   -------------------------------------------------------------

{% from "map.jinja" import dirs with context %}

{% set network = salt['node.get']('network') %}

#   -------------------------------------------------------------
#   Native IPv6
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% if salt['node.has']('network:ipv6_native') %}

{% if grains['os'] == 'FreeBSD' %}
/etc/rc.conf.d/netif/ipv6_{{ network['ipv6_interface'] }}:
  file.managed:
    - source: salt://roles/core/network/files/FreeBSD/netif_ipv6.rc
    - makedirs: True
    - template: jinja
    - context:
        interface: {{ network['ipv6_interface'] }}
        ipv6_address: {{ network['ipv6_address'] }}
        ipv6_prefix: {{ network['ipv6_prefix'] | default(64) }}
        has_native_ipv6: True
{% endif %}

{% endif %}

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
{% endif %}

#   -------------------------------------------------------------
#   Routes
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% if grains['os'] == 'FreeBSD' %}
/etc/rc.conf.d/routing/ipv6:
  file.managed:
    - source: salt://roles/core/network/files/FreeBSD/routing_ipv6.rc
    - makedirs: True
    - template: jinja
    - context:
        ipv6_gateway: {{ network['ipv6_gateway'] | default('') }}
{% endif %}
