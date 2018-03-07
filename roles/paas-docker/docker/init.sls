#   -------------------------------------------------------------
#   Salt — Provision Docker engine
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2017-05-24
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

#   -------------------------------------------------------------
#   Install Docker engine
#   -------------------------------------------------------------

{% if grains['os'] == 'CentOS' %}
remove_legacy_docker_packages:
  pkg:
    - removed
    - pkgs:
      - docker-common
      - docker-selinux
      - docker-engine

install_docker_engine:
  file.managed:
    - name: /etc/yum.repos.d/docker-ce.repo
    - source: https://download.docker.com/linux/centos/docker-ce.repo
    - source_hash: 6650718e0fe5202ae7618521f695d43a8bc051c539d7570f0edbfa5b4916f218
  pkg:
    - installed
    - pkgs:
      - device-mapper-persistent-data
      - lvm2
      - docker-ce
{% endif %}
