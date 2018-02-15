#   -------------------------------------------------------------
#   Salt — Sites to provision on the legacy web server
#
#   Currently, this is deployed to ysul.nasqueron.org
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

webserver_legacy_group:
  group.present:
    - name: web
    - gid: 9003
    - system: True

{% for domains_group in pillar['web_domains'] %}
{% for domain in pillar['web_domains'][domains_group] %}
webserver_user_{{ domain }}:
  user.present:
    - name: {{ domain }}
    - gid: 9003
    - createhome: False
    - fullname: Websites account for {{ domain }}
{% endfor %}
{% endfor %}
