#   -------------------------------------------------------------
#   Salt — Network
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
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
