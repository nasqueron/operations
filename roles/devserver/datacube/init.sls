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

{{ tank }}/datacube:
  zfs.filesystem_present:
    - properties:
        mountpoint: /datacube
        compression: zstd

{% for subdir, args in pillar.get("datacubes", {}).items() %}

{% set datacube_dataset = tank + "/datacube/" + subdir %}

{% if "user" in args %}
/datacube/{{ subdir }}:
  file.directory:
    - mode: 711
    - user: {{ args["user"] }}
{% endif %}

{{ datacube_dataset }}:
  zfs.filesystem_present:
    - properties:
        mountpoint: /datacube/{{ subdir }}
        compression: zstd
        {% if "zfs_auto_snapshot" in args %}
        "com.sun:auto-snapshot": "true"
        {% endif %}

{% if "zfs_user" in args %}
zfs_permissions_datacube_{{ subdir }}:
  cmd.run:
    - name: zfs allow -lu {{ args["zfs_user"] }} @local {{ datacube_dataset }}
    - onchanges:
        - zfs: {{ datacube_dataset }}

zfs_permissions_datacube_descendent_{{ subdir }}:
  cmd.run:
    - name: zfs allow -du {{ args["zfs_user"] }} @descendent {{ datacube_dataset }}
    - onchanges:
        - zfs: {{ datacube_dataset }}
{% endif %}

{% endfor %}
{% endif %}

#   -------------------------------------------------------------
#   Misc directories
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% for dir, args in pillar.get("devserver_directories", {}).items() %}

{{ dir }}:
  file.directory:
    - makedirs: True
    {% for key in ["user", "group", "mode"] %}
    {% if key in args %}
    - {{ key }}: {{ args[key] }}
    {% endif %}
    {% endfor %}

{% endfor %}
