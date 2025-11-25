#   -------------------------------------------------------------
#   Salt — Database server — MySQL
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2017-10-27
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import dirs with context %}

{% set use_zfs = salt['node.has']('zfs:pool') %}
{% set is_devserver = salt['node.has_role']('devserver') %}

#   -------------------------------------------------------------
#   Required directories
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/var/run/mysql:
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

{{ dirs.etc }}/mysql/conf.d:
  file.recurse:
    - source: salt://roles/dbserver-mysql/mysql-server/files/conf.d
    - clean: True # remove wsrep.cnf values (and empty config files)
    - template: jinja
    - context:
        nodename: {{ grains['id'] }}
        etc: {{ dirs.etc }}
        share: {{ dirs.share }}
        use_zfs: {{ use_zfs }}

        {% if is_devserver %}
        listen_ip: 127.0.0.1
        {% else %}
        listen_ip: 0.0.0.0
        {% endif %}

{{ dirs.etc }}/mysql/stopwords.txt:
  file.managed:
    - source: salt://roles/dbserver-mysql/mysql-server/files/stopwords.txt

#   -------------------------------------------------------------
#   Service
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% if grains['os'] == 'FreeBSD' %}

/etc/rc.conf.d/mysql:
  file.managed:
    - source: salt://roles/dbserver-mysql/mysql-server/files/mysql.rc
    - template: jinja
    - context:
        use_zfs: {{ use_zfs }}

{% endif %}
