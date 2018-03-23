#   -------------------------------------------------------------
#   Salt — Provision Docker engine
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2018-03-23
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% if grains['os_family'] == 'RedHat' %}

# On Fedora and downstreams, SELinux restricts the capability
# of HTTP server to connect to external servers.
#
# This feature allows nginx to connect to other servers,
# and so to act as a front-end server through proxy_pass.

httpd_can_network_connect:
  selinux.boolean:
    - value: True
    - persist: True

{% endif %}
