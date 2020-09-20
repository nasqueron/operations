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

{% if salt['node.has']('network:ipv6_native') %}
{% if grains['os'] == 'FreeBSD' %}
/etc/rc.conf.d/netif/ipv6_{{ network['ipv6_interface'] }}:
  file.managed:
    - source: salt://roles/core/network/files/netif_ipv6.rc
    - makedirs: True
    - template: jinja
    - context:
        interface: {{ network['ipv6_interface'] }}
        ipv6_address: {{ network['ipv6_address'] }}
        ipv6_prefix: {{ network['ipv6_prefix'] | default(64) }}
        has_native_ipv6: True
{% endif %}
{% endif %}

{% if salt['node.has']('network:ipv6_tunnel') %}
network_ipv6:
  file.managed:
    - name : {{ dirs.sbin }}/ipv6-setup-tunnel
    - source: salt://roles/core/network/files/{{ grains['id'] }}_ipv6.sh.jinja
    - template: jinja
    - mode: 755
{% endif %}

#   -------------------------------------------------------------
#   GRE tunnels
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% set gre_tunnels = salt['pillar.get']("gre_tunnels:" + grains['id'], {}) %}

{% if grains['os'] == 'FreeBSD' %}

{% set boot_loader = namespace(gre=false) %}

{% for description, tunnel in gre_tunnels.items() %}

{% set boot_loader.gre = True %}
{% set tunnel_network = pillar['networks'][tunnel['network']] %}

/etc/rc.conf.d/netif/gre_{{ description }}:
  file.managed:
    - source: salt://roles/core/network/files/netif_gre.rc
    - makedirs: True
    - template: jinja
    - context:
        description: {{ description }}
        interface: {{ tunnel['interface'] }}

        src: {{ tunnel_network['addr'][grains['id']] }}
        dst: {{ tunnel_network['addr'][tunnel['to']] }}

        icann_src: {{ network['ipv4_address'] }}
        icann_dst: {{ salt['node.get']('network', tunnel['to'])['ipv4_address'] }}
{% endfor %}

{% if boot_loader.gre %}
load_gre_kernel_module:
  file.append:
    - name: /boot/loader.conf
    - text: |

        if_gre_load="YES"
{% endif %}

{% endif %}
