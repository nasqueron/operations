#   -------------------------------------------------------------
#   Salt — Provision Docker engine
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import dirs with context %}

#   -------------------------------------------------------------
#   Configure Docker engine
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% set daemon = salt["paas_docker.build_daemon_config"]() %}

{{ dirs.etc }}/docker/daemon.json:
  file.managed:
    - source: salt://roles/paas-docker/docker/files/daemon.json.jinja
    - template: jinja
    - mode: 644
    - context:
        daemon: {{ daemon }}
