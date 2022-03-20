#   -------------------------------------------------------------
#   Salt — Provision Docker engine
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import dirs with context %}

#   -------------------------------------------------------------
#   Install a modern Python interpreter on CentOS/Rocky 7/8
#
#   Our checks uses subprocess features to capture output,
#   and as such won't work correctly on Python 3.6.
#
#   Provide python3.9 as python3 is safe as:
#    - Salt RPM package hardcode a version, e.g. #!/usr/bin/python3.6
#    - systems scripts like dnf use #!/usr/libexec/platform-python
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% if grains["pythonversion"] < [3, 9] %}

{% if grains["os_family"] == "RedHat" %}
epel_repositories:
  pkg.installed:
    - pkgs:
      - epel-release
      - epel-next-release

python_packages:
  pkg.installed:
    - pkgs:
      - python39
      - python39-pyyaml
      - python39-requests
    - require:
      - pkg: epel_repositories

/etc/alternatives/python3:
  file.symlink:
    - target: /usr/bin/python3.9
    - require:
      - pkg: python_packages
{% endif %}

{% endif %}

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
          - check_docker_containers: {{ salt['paas_docker.list_containers']() }}
