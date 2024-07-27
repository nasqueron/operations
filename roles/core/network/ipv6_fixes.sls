#   -------------------------------------------------------------
#   Salt — Network
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% set network = salt['node.get']('network') %}

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
