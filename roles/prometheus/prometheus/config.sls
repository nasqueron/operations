#   -------------------------------------------------------------
#   Salt — Provision Prometheus
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import dirs with context %}

#   -------------------------------------------------------------
#   Prometheus configuration
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{{ dirs.etc }}/prometheus.yml:
  file.managed:
    - source: salt://roles/prometheus/prometheus/files/prometheus.yml
    - template: jinja

#   -------------------------------------------------------------
#   Syslog configuration
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% if grains["os"] == "FreeBSD" %}

{{ dirs.etc }}/newsyslog.conf.d/prometheus.conf:
  file.managed:
    - source: salt://roles/prometheus/prometheus/files/syslog/newsyslog.conf
    - makedirs: True

{{ dirs.etc }}/syslog.d/prometheus.conf:
  file.managed:
    - source: salt://roles/prometheus/prometheus/files/syslog/prometheus.conf
    - makedirs: True

prometheus_newsyslog_run:
  cmd.run:
    - name: newsyslog -C
    - creates: /var/log/prometheus.log

prometheus_syslog_reload:
  cmd.run:
    - name: /etc/rc.d/syslogd reload
    - onchanges:
      - file: {{ dirs.etc }}/syslog.d/prometheus.conf

{% endif %}
