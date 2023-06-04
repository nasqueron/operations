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
#
#   Flags:
#
#    - On Online, we need to send a request to a DHCP server
#      with the assigned DUID.
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% if salt['node.has']('network:ipv6_native') %}
  {% for interface_name, interface in network["interfaces"].items() %}
    {% if "ipv6" in interface %}

      {% if grains['os'] == 'FreeBSD' %}
      /etc/rc.conf.d/netif/ipv6_{{ interface['device'] }}:
        file.managed:
          - source: salt://roles/core/network/files/FreeBSD/netif_ipv6.rc
          - makedirs: True
          - template: jinja
          - context:
              interface: {{ interface['device'] }}
              ipv6_address: {{ interface['ipv6']['address'] }}
              ipv6_prefix: {{ interface['ipv6']['prefix'] | default(64) }}
              has_native_ipv6: True

      {% if "gateway" in interface["ipv6"] %}
      /etc/rc.conf.d/routing/ipv6:
        file.managed:
          - source: salt://roles/core/network/files/FreeBSD/routing_ipv6.rc
          - makedirs: True
          - template: jinja
          - context:
              interface: {{ interface['device'] }}
              ipv6_address: {{ interface['ipv6']['address'] }}
              ipv6_prefix: {{ interface['ipv6']['prefix'] | default(64) }}
              ipv6_gateway: {{ interface['ipv6']['gateway'] }}
      {% endif %}

      {% endif %}
    {% endif %}
  {% endfor %}
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
#   Routes - legacy configuration for ipv6_gateway
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% if "ipv6_gateway" in network %}

{% if grains['os'] == 'FreeBSD' %}
/etc/rc.conf.d/routing/ipv6:
  file.managed:
    - source: salt://roles/core/network/files/FreeBSD/routing_ipv6.rc
    - makedirs: True
    - template: jinja
    - context:
        ipv6_gateway: {{ network["ipv6_gateway"] }}
{% endif %}

{% endif %}

#   -------------------------------------------------------------
#   Routes - IPv6 fix for OVH
#
#   OVH network doesn't announce an IPv6 route for a VM at first.
#   If from the VM, we reach another network, the route is then
#   announced for a while, before being dropped.
#
#   To workaround that behavior, solution is to ping regularly
#   an external site so packets reach OVH router and a route is
#   announced.
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% if salt['node.has']('fixes:hello_ipv6_ovh') %}

/usr/local/etc/cron.d/hello-ipv6:
  file.managed:
    - source: salt://roles/core/network/files/FreeBSD/hello-ipv6.cron
    - makedirs: True

{% endif %}
