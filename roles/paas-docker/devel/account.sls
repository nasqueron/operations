#   -------------------------------------------------------------
#   Salt — nasqueron-dev-docker
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import dirs with context %}

#   -------------------------------------------------------------
#   Sudo capabilities
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

nasqueron_dev_docker_sudo_capabilities_file:
  file.managed:
    - name: {{ dirs.etc }}/sudoers.d/nasqueron-dev-docker
    - source: salt://roles/paas-docker/devel/files/nasqueron-dev-docker.sudoers
