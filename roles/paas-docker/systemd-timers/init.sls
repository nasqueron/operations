#   -------------------------------------------------------------
#   Salt — Provision Docker engine
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   Service:        Nasqueron Reports
#   -------------------------------------------------------------

{% set reports_dir = pillar["nasqueron_reports"]["reports_dir"] %}

reports_dir:
  file.directory:
    - name: {{ reports_dir }}
    - user: root
    - group: root
    - mode: 755
    - makedirs: true

{% for job in pillar["nasqueron_reports"]["jobs"] %}
systemd_service_{{ job.report }}:
  file.managed:
    - name: /etc/systemd/system/report-{{ job.report }}.service
    - source: salt://roles/paas-docker/systemd-timers/files/report.service
    - template: jinja
    - context:
        reports_dir: {{ reports_dir }}
        report: {{ job.report }}

systemd_timer_{{ job.report }}:
  file.managed:
    - name: /etc/systemd/system/report-{{ job.report }}.timer
    - source: salt://roles/paas-docker/systemd-timers/files/report.timer
    - template: jinja
    - context:
        report: {{ job.report }}
        schedule: {{ job.schedule }}

systemd_timer_{{ job.report }}_enabled:
  service.enabled:
    - name: report-{{ job.report }}.timer
    - require:
      - file: systemd_timer_{{ job.report }}

systemd_timer_{{ job.report }}_running:
  service.running:
    - name: report-{{ job.report }}.timer
    - require:
      - service: systemd_timer_{{ job.report }}_enabled
{% endfor %}
