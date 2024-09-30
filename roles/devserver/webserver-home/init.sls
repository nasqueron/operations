#   -------------------------------------------------------------
#   Salt — Provision a development server
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import dirs with context %}

#   -------------------------------------------------------------
#   Home directories
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/var/home-wwwroot:
  file.directory:
    - mode: 711
    - group: web

{{ dirs.bin }}/setup-web-home:
  file.managed:
    - source: salt://roles/devserver/webserver-home/files/setup-web-home.py
    - mode: 755

#   -------------------------------------------------------------
#   ZFS datasets
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% if salt["node.has"]("zfs:pool") %}

{% set tank = salt["node.get"]("zfs:pool") %}
{% set users = salt["forest.get_users"]() %}

{{ tank }}/var/home-wwwroot:
  zfs.filesystem_present:
    - properties:
        mountpoint: /var/home-wwwroot
        compression: zstd

zfs_webserver_home_permissions_sets:
  cmd.run:
    - name: |
        zfs allow -s @local allow,clone,create,diff,hold,mount,promote,receive,release,rollback,snapshot,send {{ tank }}/var/home-wwwroot
        zfs allow -s @descendent allow,clone,create,diff,destroy,hold,mount,promote,receive,release,rename,rollback,snapshot,send {{ tank }}/var/home-wwwroot
        touch /var/home-wwwroot/.zfs-permissions-set
    - creates: /var/home-wwwroot/.zfs-permissions-set

{% for username in users %}
{% set webserver_home_directory = tank + "/var/home-wwwroot/" + username %}

{{ webserver_home_directory }}:
  zfs.filesystem_present:
    - properties:
        compression: zstd
        "com.sun:auto-snapshot": "true"

zfs_permissions_webserver_home_local_{{ username }}:
  cmd.run:
    - name: zfs allow -lu {{ username }} @local {{ webserver_home_directory }}
    - onchanges:
        - zfs: {{ webserver_home_directory }}

zfs_permissions_webserver_home_descendant_{{ username }}:
  cmd.run:
    - name: zfs allow -du {{ username }} @descendent {{ webserver_home_directory }}
    - onchanges:
        - zfs: {{ webserver_home_directory }}

/var/home-wwwroot/{{ username }}:
  file.directory:
    - user: {{ username }}
    - group: web
    - dir_mode: 755

/home/{{ username }}/public_html:
  file.symlink:
    - target: /var/home-wwwroot/{{ username }}

{% endfor %}

{% endif %}

#   -------------------------------------------------------------
#   Default vhost
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{{ dirs.etc }}/nginx/vhosts/001-server.conf:
  file.managed:
    - source: salt://roles/devserver/webserver-home/files/001-server.conf
    - mode: 644
    - template: jinja
    - context:
        hostname: {{ grains.host }}
        fqdn: {{ grains.fqdn }}
        ips: "{{ salt["node.get_all_ips"]() }}"
