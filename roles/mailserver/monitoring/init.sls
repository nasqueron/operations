#   -------------------------------------------------------------
#   Mail - Monitoring
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import dirs with context %}
{% set nrpe_dir = dirs.share + "/monitoring/checks/nrpe" %}

#   -------------------------------------------------------------
#   NRPE checks
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{{ nrpe_dir }}/check-mail-aliases:
  file.managed:
    - source: salt://roles/mailserver/monitoring/files/check-mail-aliases.sh
    - mode: 755
