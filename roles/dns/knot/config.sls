#   -------------------------------------------------------------
#   Salt — KnotDNS configuration
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import dirs with context %}

#   -------------------------------------------------------------
#   FreeBSD configuration
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/etc/sysctl.d/knot.conf:
  file.managed:
    - source: salt://roles/dns/knot/files/sysctl
    - user: root
    - group: wheel
    - mode: 644
    - makedirs: True

knot_reload_sysctl:
  cmd.run:
    - name: sysctl -f /etc/sysctl.d/knot.conf
    - onchanges:
      - file: /etc/sysctl.d/knot.conf

#   -------------------------------------------------------------
#   KnotDNS main configuration
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{{ dirs.etc }}/knot/knot.conf:
  file.managed:
    - source: salt://roles/dns/knot/files/knot.conf
    - template: jinja
    - context:
        zones: {{ pillar["dns_zones"] }}
        all_ips: {{ [ salt['node.resolve_network']()['ipv4_address'] ] + salt['node.get_public_ipv6']() }}
        identity: {{ pillar["dns_identity"] }}

#   -------------------------------------------------------------
#   KnotDNS zones files provisioning
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% set zone_vars = salt["pillar.get"]("dns_zone_variables", {}) %}

{% for zone in pillar["dns_zones"] %}

knotdns_file_{{ zone }}:
  file.managed:
    - source: salt://roles/dns/knot/files/zones/{{ zone }}.zone
    - name: /var/db/knot/{{ zone }}.zone
    - template: jinja

    # Context to sync with test_dns_zones.py::build_context
    - context:
        identity: {{ pillar["dns_identity"] }}
        vars: {{ zone_vars }}

{% endfor %}
