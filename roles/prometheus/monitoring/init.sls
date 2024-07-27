#   -------------------------------------------------------------
#   Salt :: Monitoring :: Prometheus
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import dirs with context %}

{{ dirs.share }}/monitoring/checks/nrpe/check-prometheus:
  file.managed:
    - source: salt://roles/prometheus/monitoring/files/check-prometheus.sh
    - mode: 755
    - template: jinja
    - makedirs: True
    - context:
        dirs: {{ dirs }}
