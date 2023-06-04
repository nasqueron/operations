#   -------------------------------------------------------------
#   Salt — Network
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import dirs with context %}

#   -------------------------------------------------------------
#   DHCPv6 client
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% set duid_credentials = salt["credentials.get_duid_credentials"]() %}

{% if duid_credentials %}

      {% if grains["os"] == "FreeBSD" %}

      ipv6_dhcp:
        pkg.installed:
          - pkgs:
            - isc-dhcp44-client

      /usr/local/etc/rc.d/dhclient6:
        file.managed:
         - source: salt://roles/core/network/files/FreeBSD/dhclient6.service
         - mode: 755

      /etc/rc.conf.d/dhclient6:
        file.managed:
         - source: salt://roles/core/network/files/FreeBSD/dhclient6.rc
         - mode: 644
         - template: jinja
         - context:
             interface: {{ salt["convert.to_list"](duid_credentials)[0] }}

      {% endif %}

      {{ dirs.etc }}/dhclient6.conf:
        file.managed:
          - source: salt://roles/core/network/files/dhclient6.conf
          - mode: 400
          - show_changes: False
          - template: jinja
          - context:
              credentials: {{ duid_credentials }}

{% endif %}
