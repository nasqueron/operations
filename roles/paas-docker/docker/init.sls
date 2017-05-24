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
      - container-selinux
      - docker-selinux
      - docker-engine

install_docker_engine:
  file.managed:
    - name: /etc/yum.repos.d/docker-ce.repo
    - source: https://download.docker.com/linux/centos/docker-ce.repo
    - source_hash: 257562ba65fb37d13ad0a449c21ebdd43aeb8963ca267133e6eb57ca8c89611e
  pkg:
    - installed
    - pkgs:
      - device-mapper-persistent-data
      - lvm2
      - docker-ce  
{% endif %}
