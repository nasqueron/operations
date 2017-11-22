#   -------------------------------------------------------------
#   Salt — Provision PHP websites
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

#   -------------------------------------------------------------
#   Sites user accounts
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% for domain, site in pillar['web_php_sites'].iteritems() %}

web_account_{{ site['user'] }}:
  user.present:
    - name: {{ site['user' ]}}
    - fullname: {{ domain }}
    - gid: web
    - system: True
    - home: /var/run/web/{{ domain }}

{% endfor %}
