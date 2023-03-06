#   -------------------------------------------------------------
#   Salt — Salt configuration
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2018-03-10
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import dirs, packages_prefixes with context %}

#   -------------------------------------------------------------
#   Dependencies for Docker Salt minions
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

required_python_packages_for_docker_and_salt:
  pkg.installed:
    - name: {{ packages_prefixes.python3 }}pip
  pip.installed:
    - name: docker < 6.0
    - bin_env: /usr/bin/pip3
    - reload_modules: True
    - require:
      - pkg: required_python_packages_for_docker_and_salt

#   -------------------------------------------------------------
#   Wrapper to fetch a credential
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

credential_dependencies:
  pkg.installed:
    - name: jq

{{ dirs.bin }}/credential:
  file.managed:
    - source: salt://roles/paas-docker/salt/files/credential.sh
    - mode: 755
