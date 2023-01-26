#   -------------------------------------------------------------
#   Salt — Network
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "roles/core/network/map.jinja" import routes_config with context %}

#   -------------------------------------------------------------
#   Routes
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{{ routes_config["config_path"] }}:
  file.managed:
    - source: salt://roles/core/network/files/{{ routes_config["source_path"] }}
    - makedirs: True
    - template: jinja
    - context:
        routes: {{ salt["node.get_routes"]() }}

#   -------------------------------------------------------------
#   Enable packet forwarding for routers
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% if "router" in grains['roles'] %}
{% if grains['os'] == 'FreeBSD' %}

/etc/rc.d/routing/router:
  file.managed:
    - source: salt://roles/core/network/files/FreeBSD/router.rc
    - makedirs: True

{% endif %}
{% endif %}

#   -------------------------------------------------------------
#   Systemd unit for Linux systems using our /etc/routes.conf
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% if routes_config["provider"] == "custom-service" %}

/usr/sbin/routes:
  file.managed:
    - source: salt://roles/core/network/files/Linux/routes.sh
    - mode: 755

/etc/systemd/system/routes.service:
  file.managed:
    - source: salt://roles/core/network/files/Linux/routes.service
  service.running:
    - name: routes
    - enable: true

{% endif %}
