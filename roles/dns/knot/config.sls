#   -------------------------------------------------------------
#   Salt — KnotDNS configuration
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import dirs with context %}

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

{% for zone in pillar["dns_zones"] %}

knotdns_file_{{ zone }}:
  file.managed:
    - source: salt://roles/dns/knot/files/zones/{{ zone }}.zone
    - name: /var/db/knot/{{ zone }}.zone
    - template: jinja
    - context:
        identity: {{ pillar["dns_identity"] }}
{% endfor %}
