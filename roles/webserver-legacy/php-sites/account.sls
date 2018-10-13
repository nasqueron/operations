#   -------------------------------------------------------------
#   Salt — Provision PHP websites
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

#   -------------------------------------------------------------
#   Sites user accounts
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% for fqdn, site in pillar['web_php_sites'].items() %}
{% if 'skipCreateAccount' not in site or not site['skipCreateAccount'] %}

web_account_{{ site['user'] }}:
  user.present:
    - name: {{ site['user' ]}}
    - fullname: {{ fqdn }}
    - gid: web
    - system: True
    - home: /var/run/web/{{ fqdn }}

{% endif %}
{% endfor %}
