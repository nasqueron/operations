#   -------------------------------------------------------------
#   Salt — MOTD
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2016-04-10
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% set network = salt['node.get']('network') %}

motd:
  file.managed:
    {% if grains['os_family'] == 'Debian' %}
    - name: /etc/motd.tail
    {% else %}
    - name: /etc/motd
    {% endif %}
    - source: salt://roles/core/motd/files/{{ grains['id'] }}
    - template: jinja
    - context:
        ipv4_address: {{ network['ipv4_address'] }}
        ipv4_gateway: {{ network['ipv4_gateway'] }}

# Fixes T858
get_rid_of_scaleway_motd:
  file.absent:
    - name: /etc/update-motd.d/50-scw

/usr/local/bin/motd:
  file.managed:
    - source: salt://roles/core/motd/files/motd.sh
    - mode: 755
