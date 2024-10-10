#   -------------------------------------------------------------
#   Salt :: Alkane :: Nasqueron PaaS for static and PHP sites
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import dirs, services with context %}

{% set network = salt["node.resolve_network"]() %}

#   -------------------------------------------------------------
#   Export php-fpm metrics
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

phpfpm_exporter_lusitaniae:
  pkg.installed

{% if services["manager"] == "rc" %}

/etc/rc.conf.d/phpfpm_exporter.conf:
  file.managed:
    - source: salt://roles/webserver-alkane/monitoring/files/rc/phpfpm_exporter.conf
    - template: jinja
    - context:
        ip: {{ network.private_ipv4_address }}

{% endif %}
