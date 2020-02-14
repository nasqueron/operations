#   -------------------------------------------------------------
#   Salt — Salt configuration
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2018-03-10
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

#   -------------------------------------------------------------
#   Dependencies for Docker Salt minions
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

required_python_packages_for_docker_and_salt:
  pip.installed:
    - name: docker
    - bin_env: /usr/bin/pip3
