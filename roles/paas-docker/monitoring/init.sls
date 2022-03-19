#   -------------------------------------------------------------
#   Salt — Provision Docker engine
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import dirs with context %}

#   -------------------------------------------------------------
#   Platform checks
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

platform-checks:
  pip.installed

#   -------------------------------------------------------------
#   Health check configuration
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{{ dirs.etc }}/monitoring/checks.yml:
  file.managed:
    - source: salt://roles/paas-docker/monitoring/files/checks.yml.jinja
    - makedirs: True
    - mode: 0644
    - template: jinja
    - context:
        checks:
          - {{ salt['paas_docker.get_health_checks']() }}
