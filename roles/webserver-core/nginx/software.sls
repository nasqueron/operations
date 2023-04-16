#   -------------------------------------------------------------
#   Salt — Webserver core units for all webservers roles
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import services with context %}

#   -------------------------------------------------------------
#   Software
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

nginx:
  pkg.installed

#   -------------------------------------------------------------
#   Service
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% if services.manager == "rc" %}
/etc/rc.conf.d/nginx:
  file.managed:
    - source: salt://roles/webserver-core/nginx/files/nginx.rc
{% endif %}

nginx_service:
  service.running:
    - name: nginx
    - enable: true
