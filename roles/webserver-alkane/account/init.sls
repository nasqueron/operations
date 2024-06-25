#   -------------------------------------------------------------
#   Salt — Sites to provision
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

#   -------------------------------------------------------------
#   User groups for domains served
#
#   Those accounts are mostly intended for static content,
#   to allow users to access it through group.
#
#   The user will often be "deploy" to allow continuous delivery.
#   This is provisioned by the core role.
#
#   Back-ends runs under their own separate account.
#
#   The 9003 group matches "web" group, see webserver-core/nginx
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

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

#   -------------------------------------------------------------
#   PHP user accounts
#
#   Those accounts are intended to serve content through php-fpm.
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% for fqdn, site in pillar['web_php_sites'].items() %}
{% if 'skipCreateUser' not in site or not site['skipCreateUser'] %}

webserver_user_{{ site['user'] }}:
  user.present:
    - name: {{ site['user' ] }}
    - fullname: {{ fqdn }}
{% if 'uid' in site %}
    - uid: {{ site['uid']  }}
{% endif %}
    - gid: 9003
    - system: True
    - home: /var/run/web/{{ fqdn }}

{% endif %}
{% endfor %}
