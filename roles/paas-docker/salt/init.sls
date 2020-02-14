#   -------------------------------------------------------------
#   Salt — Salt configuration
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2018-03-10
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import packages_prefixes with context %}

#   -------------------------------------------------------------
#   Dependencies for Docker Salt minions
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

required_python_packages_for_docker_and_salt:
  pkg.installed:
    - name: {{ packages_prefixes.python3 }}pip
  pip.installed:
    - name: docker
    - bin_env: /usr/bin/pip3
    - require:
      - pkg: required_python_packages_for_docker_and_salt
