#   -------------------------------------------------------------
#   Salt — Provision dev software
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

#   -------------------------------------------------------------
#   Directory
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/datacube:
  file.directory:
    - mode: 711

#   -------------------------------------------------------------
#   ZFS
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


{% if salt['node.has']('zfs:pool') %}

{% set tank = salt['node.get']("zfs:pool") %}
{% set subdirs = ["bak", "git", "t"] %}

{{ tank }}/datacube:
  zfs.filesystem_present:
    - properties:
        mountpoint: /datacube
        compression: zstd

{% for subdir in subdirs %}
{{ tank }}/datacube/{{ subdir }}:
  zfs.filesystem_present:
    - properties:
        mountpoint: /datacube/{{ subdir }}
        compression: zstd
{% endfor %}

{% endif %}
