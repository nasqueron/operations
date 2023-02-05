#   -------------------------------------------------------------
#   Salt — Provision Docker engine
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2017-05-24
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "map.jinja" import services with context %}

#   -------------------------------------------------------------
#   Install Docker engine
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

{% if grains['os_family'] == 'RedHat' and grains['os'] != 'Fedora' %}
remove_legacy_docker_packages:
  pkg.removed:
    - pkgs:
      - docker-common
      - docker-selinux
      - docker-engine

install_docker_engine_dependencies:
  file.managed:
    - name: /etc/yum.repos.d/docker-ce.repo
    - source: https://download.docker.com/linux/centos/docker-ce.repo
    - source_hash: 8ab5599eef0afcac10cbd3e8670873efee20fcceb5fb3526a62edeade603cec7
  pkg.installed:
    - pkgs:
      - device-mapper-persistent-data
      - lvm2
    - require:
      - file: install_docker_engine_dependencies

# CentOS 8 can't install docker-ce last version if containerd.io isn't recent enough.
install_docker_engine:
  cmd.run:
    - name: dnf install -y docker-ce --nobest
    - creates: /usr/bin/dockerd
{% endif %}

#   -------------------------------------------------------------
#   Service
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

start_docker_service:
  service.running:
    - name: docker
    - enable: true

#   -------------------------------------------------------------
#   Additional utilities
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

install_docker_extra_packages:
  pkg.installed:
    - pkgs:
      - docker-processes
