#   -------------------------------------------------------------
#   Salt — Database server — MySQL
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2017-10-27
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% if salt['node.has']('zfs:pool') %}

{% set tank = salt['node.get']("zfs:pool") %}

{{ tank }}/mysql-root:
  zfs.filesystem_present:
    # This one is optimized for MyISAM
    - properties:
        mountpoint: /var/db/mysql/data
        compression: lz4
        recordsize: 8K

{% for mysqldir in ['innodb-data', 'innodb-logs'] %}
/var/db/mysql/mysql-{{ mysqldir }}:
  file.directory:
    - user: mysql
    - group: mysql
    - dir_mode: 711
{% endfor %}

{{ tank }}/mysql-innodb-data:
  zfs.filesystem_present:
    - properties:
        mountpoint: /var/db/mysql/mysql-innodb-data
        compression: lz4
        recordsize: 16K
        primarycache: metadata

{{ tank }}/mysql-innodb-logs:
  zfs.filesystem_present:
    - properties:
        mountpoint: /var/db/mysql/mysql-innodb-logs
        compression: lz4
        recordsize: 128K
        primarycache: metadata

{% endif %}
