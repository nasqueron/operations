#   -------------------------------------------------------------
#   Salt — Sites to provision on the legacy web server
#
#   Currently, this is deployed to ysul.nasqueron.org
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

/var/wwwroot:
  file.directory:
     - group: web
     - dir_mode: 711

/var/log/www:
  file.directory:
     - group: web
     - dir_mode: 711

{% for domains_group in pillar['web_domains'] %}
{% for domain in pillar['web_domains'][domains_group] %}
webserver_directory_{{ domain }}:
  file.directory:
    - name: /var/wwwroot/{{ domain }}
    - user: {{ domain }}
    - group: web
    - dir_mode: 711

/var/log/www/{{ domain }}:
  file.directory:
    - user: {{ domain }}
    - group: web
    - dir_mode: 711
{% endfor %}
{% endfor %}

/var/run/web:
  file.directory:
     - group: web
     - dir_mode: 711
