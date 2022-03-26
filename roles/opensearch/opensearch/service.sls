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

opensearch_unit:
  file.managed:
    - name: /etc/systemd/system/opensearch.service
    - source: salt://roles/opensearch/opensearch/files/opensearch.service
    - mode: 644
  service.running:
    - name: opensearch
    - enable: true
    - watch:
      - file: opensearch_unit

{% endif %}
