#   -------------------------------------------------------------
#   Salt — Sites to provision on the legacy web serves
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2017-04-28
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import dirs with context %}
{% set zr_home = "/home/zr" %}

#   -------------------------------------------------------------
#   But first, we interrupt your configuration for some ASCI art.
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#
#
#        ___           ___           ___           ___           ___
#       /  /\         /  /\         /__/\         /__/|         /  /\
#      /  /::|       /  /:/_       |  |::\       |  |:|        /  /:/_
#     /  /:/:|      /  /:/ /\      |  |:|:\      |  |:|       /  /:/ /\
#    /  /:/|:|__   /  /:/ /:/_   __|__|:|\:\   __|  |:|      /  /:/ /:/_
#   /__/:/ |:| /\ /__/:/ /:/ /\ /__/::::| \:\ /__/\_|:|____ /__/:/ /:/ /\
#   \__\/  |:|/:/ \  \:\/:/ /:/ \  \:\~~\__\/ \  \:\/:::::/ \  \:\/:/ /:/
#       |  |:/:/   \  \::/ /:/   \  \:\        \  \::/~~~~   \  \::/ /:/
#       |  |::/     \  \:\/:/     \  \:\        \  \:\        \  \:\/:/
#       |  |:/       \  \::/       \  \:\        \  \:\        \  \::/
#       |__|/   ___   \__\/   ___   \__\/         \__\/ ___     \__\/ ___
#              /  /\         /__/\          ___        /__/\         /  /\
#             /  /::\        \  \:\        /__/|       \  \:\       /  /:/_
#            /  /:/\:\        \__\:\      |  |:|        \  \:\     /  /:/ /\
#           /  /:/~/:/    ___ /  /::\     |  |:|    _____\__\:\   /  /:/ /:/_
#          /__/:/ /:/___ /__/\  /:/\:\  __|__|:|   /__/::::::::\ /__/:/ /:/ /\
#          \  \:\/:::::/ \  \:\/:/__\/ /__/::::\   \  \:\~~\~~\/ \  \:\/:/ /:/
#          \  \::/~~~~   \  \::/         ~\~~\:\   \  \:\  ~~~   \  \::/ /:/
#           \  \:\        \  \:\           \  \:\   \  \:\        \  \:\/:/
#            \  \:\        \  \:\           \__\/    \  \:\        \  \::/
#             \__\/         \__\/                     \__\/         \__\/
#

#   -------------------------------------------------------------
#   Required software
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
#   Account
#
#   This account is used by Jenkins jobs to deploy artefacts
#   after a build.
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

zr_account:
  user.present:
    - name: zr
    - fullname: Zemke-Rhyne
    - uid: 8900
    - gid: 9002
    - home: {{ zr_home }}

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

zr_make:
  cmd.run:
    - name: make
    - runas: zr
    - cwd: {{ zr_home }}
    - creates: {{ zr_home }}/.ssh/authorized_keys
    - require:
      - user: zr_account
      - file: {{ zr_home }}/Makefile
