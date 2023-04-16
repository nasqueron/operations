#   -------------------------------------------------------------
#   Salt — Sites to provision
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

#   -------------------------------------------------------------
#   User groups for domains served
#
#   Those account are mostly intended for static content,
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
