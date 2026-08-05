#   -------------------------------------------------------------
#   Salt — Sites to provision
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% set uids = pillar["uids"] %}
{% set gids = pillar["gids"] %}

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
#   The web group is shared with webserver-core/nginx.
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% for domains_group in pillar["web_domains"] %}
{% for domain in pillar["web_domains"][domains_group] %}
webserver_user_{{ domain }}:
  user.present:
    - name: {{ domain }}
    - gid: {{ gids["web"] }}
    - createhome: False
    - fullname: Websites account for {{ domain }}
{% endfor %}
{% endfor %}

#   -------------------------------------------------------------
#   PHP user accounts
#
#   Those accounts are intended to serve content through php-fpm.
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% for fqdn, site in pillar["web_php_sites"].items() %}
{% if "skipCreateUser" not in site or not site["skipCreateUser"] %}
{% set uid = site.get("uid", uids.get(site["user"])) %}

webserver_user_{{ site["user"] }}:
  user.present:
    - name: {{ site["user" ] }}
    - fullname: {{ fqdn }}
{% if uid is not none %}
    - uid: {{ uid }}
{% endif %}
    - gid: {{ gids["web"] }}
    - system: True
    - home: /var/run/web/{{ fqdn }}

{% endif %}
{% endfor %}
