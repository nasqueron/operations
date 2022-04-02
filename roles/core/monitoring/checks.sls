#   -------------------------------------------------------------
#   Salt — Monitoring
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import dirs with context %}
{% set nrpe_dir = dirs.share + "/monitoring/checks/nrpe" %}

{{ nrpe_dir }}:
  file.directory:
    - makedirs: True

#   -------------------------------------------------------------
#   OS or distro specific
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% set os_family_support = [
    "FreeBSD",
] %}

{% if grains["os_family"] in os_family_support %}
monitoring_checks_freebsd:
  file.recurse:
    - source: salt://roles/core/monitoring/files/checks/nrpe/os_family/{{ grains["os_family"] }}
    - name: {{ nrpe_dir }}
    - file_mode: keep
{% endif %}
