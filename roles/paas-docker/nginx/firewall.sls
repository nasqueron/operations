#   -------------------------------------------------------------
#   Salt — Provision Docker engine
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2018-03-23
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% if grains['os_family'] == 'RedHat' %}

nginx_enable_firewall:
  firewalld.present:
    - name: public
    - prune_services: False
    - services:
      - http
      - https

nginx_enable_firewall_reload:
  service.running:
    - name: firewalld
    - reload: True
    - watch:
      - firewalld: nginx_enable_firewall

{% endif %}
