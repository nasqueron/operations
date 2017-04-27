#   -------------------------------------------------------------
#   Salt — Deploy Odderon unit (darkbot)
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2017-01-25
#   Description:    Darkbot unit (Freenode)
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import services with context %}

#   -------------------------------------------------------------
#   Unit configuration 
#   -------------------------------------------------------------

{% if services['manager'] == 'systemd' %}

odderon_unit:
  file.managed:
    - name: /etc/systemd/system/odderon.service
    - source: salt://roles/shellserver/odderon/files/odderon.service
    - mode: 0644
  module.run:
    - name: service.force_reload
    - m_name: odderon
    - onchanges:
       - file: odderon_unit

odderon_running:
  service.running:
    - name: odderon
    - enable: true
    - watch:
      - module: odderon_unit

{% endif %}
