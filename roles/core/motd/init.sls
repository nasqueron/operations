#   -------------------------------------------------------------
#   Salt — MOTD
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2016-04-10
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% set motd_path = salt['motd.get_path']() %}
{% set network = salt['node.get']('network') %}

motd:
  file.managed:
    - name: {{ motd_path }}
    - source: salt://roles/core/motd/files/{{ grains['id'] }}
    - template: jinja
    - context:
        ipv4_address: {{ network['ipv4_address'] }}
        ipv4_gateway: {{ network['ipv4_gateway'] }}

#   -------------------------------------------------------------
#   Provide a `motd` command to read /etc/motd
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/usr/local/bin/motd:
  file.managed:
    - source: salt://roles/core/motd/files/motd.sh
    - mode: 755

{% if motd_path != "/etc/motd" %}
/etc/motd:
  file.symlink:
    - target: {{ motd_path }}
{% endif %}

#   -------------------------------------------------------------
#   Scaleway instances
#
#   Fixes T858.
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

get_rid_of_scaleway_motd:
  file.absent:
    - name: /etc/update-motd.d/50-scw

#   -------------------------------------------------------------
#   Generate MOTD from templates
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% if grains['os_family'] == 'FreeBSD' and grains['osmajorrelease'] >= 13 %}

update_motd:
  cmd.run:
    - name: service motd restart
    - onchanges:
      - file: motd

{% endif %}
