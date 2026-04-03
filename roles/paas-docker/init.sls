#   -------------------------------------------------------------
#   Salt — Provision Docker engine
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import dirs with context %}

include:
  - .kernel
  - .salt
  - .docker
  - .containers
  - .systemd-unit
  - .systemd-timers
  - .wwwroot-502
  - .wwwroot-content
  - .anubis
  - .nginx
  - .monitoring
  - .wrappers
{% if salt['node.has']('flags:install_docker_devel_tools') %}
  - .devel
{% endif %}
