#   -------------------------------------------------------------
#   Salt — Database server — MySQL
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2017-10-27
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import dirs with context %}

{% set use_zfs = salt['node.has']('zfs:pool') %}

#   -------------------------------------------------------------
#   Required directories
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/var/run/mysqld:
  file.directory:
    - user: mysql
    - group: mysql
    - dir_mode: 755

/var/db/mysql:
  file.directory:
    - user: mysql
    - group: mysql
    - dir_mode: 755

{{ dirs.etc }}/mysql:
  file.directory:
    - user: root
    - group: mysql
    - dir_mode: 755

#   -------------------------------------------------------------
#   Configuration files
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{{ dirs.etc }}/my.cnf:
  file.managed:
    - source: salt://roles/dbserver-mysql/mysql-server/files/my.cnf
    - template: jinja
    - context:
        nodename: {{ grains['id'] }}
        etc: {{ dirs.etc }}
        share: {{ dirs.share }}
        use_zfs: {{ use_zfs }}

{{ dirs.etc }}/mysql/stopwords.txt:
  file.managed:
    - source: salt://roles/dbserver-mysql/mysql-server/files/stopwords.txt

/etc/rc.conf.d/mysql:
  file.managed:
    - source: salt://roles/dbserver-mysql/mysql-server/files/mysql.rc
    - template: jinja
    - context:
        use_zfs: {{ use_zfs }}
