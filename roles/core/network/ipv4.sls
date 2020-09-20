#   -------------------------------------------------------------
#   Salt — Network
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2016-06-15
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% set network = salt['node.get']('network') %}

#   -------------------------------------------------------------
#   Interface
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% if grains['os'] == 'FreeBSD' %}
/etc/rc.conf.d/netif/ipv4_{{ network['ipv4_interface'] }}:
  file.managed:
    - source: salt://roles/core/network/files/FreeBSD/netif_ipv4.rc
    - makedirs: True
    - template: jinja
    - context:
        interface: {{ network['ipv4_interface'] }}
        ipv4_address: {{ network['ipv4_address'] }}
        ipv4_netmask: {{ network['ipv4_netmask'] | default('255.255.255.0') }}
        ipv4_aliases: {{ salt['node.get_list']('network:ipv4_aliases') }}
        dhcp_required: {{ salt['node.has']('network:dhcp_required') }}
{% endif %}

#   -------------------------------------------------------------
#   Routes
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% if grains['os'] == 'FreeBSD' %}
/etc/rc.conf.d/routing/ipv4:
  file.managed:
    - source: salt://roles/core/network/files/FreeBSD/routing_ipv4.rc
    - makedirs: True
    - template: jinja
    - context:
        ipv4_gateway: {{ network['ipv4_gateway'] }}
{% endif %}
