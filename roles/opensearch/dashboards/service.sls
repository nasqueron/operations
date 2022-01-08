#   -------------------------------------------------------------
#   Salt — Provision OpenSearch
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

#   -------------------------------------------------------------
#   systemd
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% from "map.jinja" import services with context %}

#   -------------------------------------------------------------
#   Unit configuration
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% if services['manager'] == 'systemd' %}

opensearch_dashboards_unit:
  file.managed:
    - name: /etc/systemd/system/dashboards.service
    - source: salt://roles/opensearch/dashboards/files/dashboards.service
    - mode: 0644
  service.running:
    - name: dashboards
    - enable: true
    - watch:
      - file: opensearch_dashboards_unit

{% endif %}
