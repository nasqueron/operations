#   -------------------------------------------------------------
#   Salt — Storage
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% set zfs_tank = salt['node.get']("zfs:pool") %}

{% if zfs_tank %}
zfstools:
  pkg.installed

/etc/cron.d/zfs:
  file.managed:
    - source: salt://roles/core/storage/files/zfs.cron
{% endif %}
