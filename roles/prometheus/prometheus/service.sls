#   -------------------------------------------------------------
#   Salt — Provision Prometheus
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

#   -------------------------------------------------------------
#   Prometheus service
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% if grains['os'] == 'FreeBSD' %}

/usr/local/etc/rc.d/prometheus:
  file.managed:
    - source: salt://roles/prometheus/prometheus/files/rc/prometheus
    - mode: 755

/etc/rc.conf.d/prometheus:
  file.managed:
    - source: salt://roles/prometheus/prometheus/files/rc/prometheus.conf
    - template: jinja
    - context:
        ip: {{ pillar["nasqueron_services"]["prometheus"] }}

{% endif %}

prometheus_running:
  service.running:
    - name: prometheus

