#   -------------------------------------------------------------
#   Salt — Network
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2020-09-24
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% set network = salt['node.get']('network') %}

#   -------------------------------------------------------------
#   Interface
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% if salt['node.has']('network:private_interface') %}

{% if grains['os'] == 'FreeBSD' %}
/etc/rc.conf.d/netif/ipv4_{{ network['private_interface'] }}:
  file.managed:
    - source: salt://roles/core/network/files/FreeBSD/netif_ipv4.rc
    - makedirs: True
    - template: jinja
    - context:
        interface: {{ network['private_interface'] }}
        ipv4_address: {{ network['private_address'] }}
        ipv4_netmask: {{ network['private_netmask'] | default('255.255.255.0') }}
        ipv4_aliases: {{ salt['node.get_list']('network:private_aliases') }}
        dhcp_required: False
{% endif %}

{% endif %}
