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
{% set interface = network['private_interface'] %}

{% if grains['os'] == 'FreeBSD' %}
/etc/rc.conf.d/netif/ipv4_{{ network['private_interface'] }}:
  file.managed:
    - source: salt://roles/core/network/files/FreeBSD/netif_ipv4.rc
    - makedirs: True
    - template: jinja
    - context:
        interface: {{ interface['device'] }}
        ipv4_address: {{ interface['address'] }}
        ipv4_netmask: {{ interface['netmask'] | default('255.255.255.0') }}
        ipv4_aliases: {{ salt['node.get_list']('network:private_interface:aliases') }}
{% endif %}

{% if grains['os_family'] == 'RedHat' %}
/etc/sysconfig/network-scripts/ifcfg-{{ interface['device'] }}:
  file.managed:
    - source: salt://roles/core/network/files/RedHat/ifcfg-private
    - template: jinja
    - context:
        interface: {{ interface }}
        prefix: {{ salt['network_utils.netmask_to_cidr_prefix'](interface['netmask']) }}
{% endif %}

{% endif %}
