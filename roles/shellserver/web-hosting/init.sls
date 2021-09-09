#   -------------------------------------------------------------
#   Salt — nginx configuration
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Eglide
#   Created:        2016-11-08
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import dirs with context %}
{% set wwwgroup = "www-data" %}

#   -------------------------------------------------------------
#   Nginx configuration files
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

nginx_config_files:
  file.recurse:
    - name: {{ dirs.etc }}/nginx
    - source: salt://roles/shellserver/web-hosting/files/{{ grains['id'] }}/nginx
    - include_empty: True
    - clean: False
    - dir_mode: 755
    - file_mode: 644
  cmd.run:
    - name: nginx -s reload
    - onchanges:
      - file: nginx_config_files

#   -------------------------------------------------------------
#   Nginx logs
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/var/log/www:
  file.directory:
    - user: root
    - group: {{ wwwgroup }}
    - dir_mode: 750

/var/log/www/eglide.org:
  file.directory:
    - user: root
    - group: {{ wwwgroup }}
    - dir_mode: 750

#   -------------------------------------------------------------
#   Site to serve when Host: header doesn't match a known vhost
#
#   Typically, this occurs when a domain is configured in DNS,
#   but not in nginx.
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

unknown_domain_files:
  file.recurse:
    - name: /var/wwwroot/unknown_domains
    - source: salt://roles/shellserver/web-hosting/files/{{ grains['id'] }}/wwwroot-unknown
    - dir_mode: 755
    - file_mode: 644
