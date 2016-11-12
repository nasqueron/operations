#   -------------------------------------------------------------
#   Salt — nginx configuration
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Eglide
#   Created:        2016-11-08
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

#   -------------------------------------------------------------
#   Nginx configuration files
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

nginx_config_files:
  file.recurse:
    {% if grains['os'] == 'FreeBSD' %}
    - name: /usr/local/etc/nginx
    {% else %}
    - name: /etc/nginx
    {% endif %}
    - source: salt://roles/shellserver/web-hosting/files/{{ grains['id'] }}/nginx
    - include_empty: True
    - clean: False
    - dir_mode: 755
    - file_mode: 644
    - cmd.run:
      - name: nginx -s reload
      - onchanges:
        {% if grains['os'] == 'FreeBSD' %}
        - file: /usr/local/etc/nginx/nginx.conf
        {% else %}
        - file: /etc/nginx/nginx.conf
        {% endif %}

#   -------------------------------------------------------------
#   Nginx logs
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/var/log/www:
  file.directory:
    - user: root
    - group: www-data
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
