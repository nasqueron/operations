#   -------------------------------------------------------------
#   Salt — Provision Docker engine
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import dirs, services with context %}

#   -------------------------------------------------------------
#   Helper executables to start and stop containers
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% for action in ['start', 'stop'] %}

{{ dirs.bin }}/docker-paas-{{ action }}-containers:
  file.managed:
    - source: salt://roles/paas-docker/systemd-unit/files/docker-paas-{{ action }}-containers.sh
    - mode: 755

{% endfor %}

#   -------------------------------------------------------------
#   Service
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% if services['manager'] == 'systemd' %}

docker-containers_unit:
  file.managed:
    - name: /etc/systemd/system/docker-containers.service
    - source: salt://roles/paas-docker/systemd-unit/files/docker-containers.service
    - mode: 644
  module.run:
    - service.force_reload:
      - name: docker-containers
    - onchanges:
       - file: docker-containers_unit

docker-containers_running:
  service.running:
    - name: docker-containers
    - enable: true
    - watch:
      - module: docker-containers_unit

{% endif %}
