#   -------------------------------------------------------------
#   Salt — Provision Docker engine
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2018-09-18
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import dirs with context %}

#   -------------------------------------------------------------
#   Configure lvm profile
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% if grains['id'] in pillar['docker_devicemapper'] %}

{% set dm = pillar['docker_devicemapper'][grains['id']] %}
{% set volume = dm['thinpool'].replace('-', '/') %}

lvm_thinpool_profile:
  file.managed:
    - source: salt://roles/paas-docker/docker/files/thinpool.profile
    - name: {{ dirs.etc }}/lvm/profile/{{ dm['thinpool'] }}.profile
    - mode: 644

lvm_apply_thinpool_profile:
  cmd.run:
    - name: |
        lvchange --metadataprofile {{ dm['thinpool'] }} {{ volume }}
        lvs -o+seg_monitor
    - onchanges:
      - file: lvm_thinpool_profile

{% endif %}
