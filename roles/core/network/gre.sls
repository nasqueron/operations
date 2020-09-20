#   -------------------------------------------------------------
#   Salt — Network — GRE tunnels
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2020-09-20
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% set network = salt['node.get']('network') %}
{% set gre_tunnels = salt['pillar.get']("gre_tunnels:" + grains['id'], {}) %}
{% set boot_loader = namespace(gre=false) %}

#   -------------------------------------------------------------
#   Tunnels network configuration files
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% for description, tunnel in gre_tunnels.items() %}

{% set boot_loader.gre = True %}
{% set tunnel_network = pillar['networks'][tunnel['network']] %}

{% if grains['os'] == 'FreeBSD' %}
/etc/rc.conf.d/netif/gre_{{ description }}:
  file.managed:
    - source: salt://roles/core/network/files/FreeBSD/netif_gre.rc
    - makedirs: True
    - template: jinja
    - context:
        description: {{ description }}
        interface: {{ tunnel['interface'] }}

        src: {{ tunnel_network['addr'][grains['id']] }}
        dst: {{ tunnel_network['addr'][tunnel['to']] }}

        icann_src: {{ network['ipv4_address'] }}
        icann_dst: {{ salt['node.get']('network', tunnel['to'])['ipv4_address'] }}
{% endif %}

{% endfor %}

#   -------------------------------------------------------------
#   Kernel configuration
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% if boot_loader.gre %}

{% if grains['os'] == 'FreeBSD' %}
load_gre_kernel_module:
  file.append:
    - name: /boot/loader.conf
    - text: |

        if_gre_load="YES"
{% endif %}

{% endif %}
