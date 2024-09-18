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
