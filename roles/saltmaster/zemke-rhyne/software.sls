#   -------------------------------------------------------------
#   Salt — Provision Docker engine
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2017-04-28
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import dirs with context %}
{% set zr_home = "/home/zr" %}

#   -------------------------------------------------------------
#   Required dependencies
#
#   :: jq
#   :: arc
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

zr_required_sofware:
  pkg.installed:
    - pkgs:
      - jq

      # Devserver role provides their own Git clone of Arcanist
      # For other servers, we need the package.
      {% if not salt['node.has_role']('devserver') %}
      - arcanist
      {% endif %}

#   -------------------------------------------------------------
#   Deploy files and directory
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% for dir in ['data', 'lib'] %}
{{ zr_home }}/{{ dir }}:
  file.recurse:
    - source: salt://software/zemke-rhyne/{{ dir }}
    - include_empty: True
    - clean: False
    - dir_mode: 755
    - file_mode: 644
    - user: 8900
    - group: 9002
{% endfor %}

{{ zr_home }}/bin:
  file.recurse:
    - source: salt://software/zemke-rhyne/bin
    - dir_mode: 755
    - file_mode: 755
    - user: 8900
    - group: 9002

{% for file in ['README', 'Makefile', '.arcconfig', '.arclint'] %}
{{ zr_home }}/{{ file }}:
  file.managed:
    - source: salt://software/zemke-rhyne/{{ file }}
    - mode: 644
    - user: 8900
    - group: 9002
{% endfor %}

{{ zr_home }}/.arcrc:
  file.managed:
    - source: salt://roles/webserver-legacy/zr/files/dot.arcrc.json
    - replace: False
    - mode: 600
    - user: 8900
    - group: 9002
