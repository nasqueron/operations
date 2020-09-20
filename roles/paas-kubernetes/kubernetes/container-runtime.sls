#   -------------------------------------------------------------
#   Salt — Kubernetes
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2020-09-20
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

{% from "roles/paas-kubernetes/map.jinja" import k8s with context %}

#   -------------------------------------------------------------
#   Kernel configuration
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

overlay:
  kmod.present:
    - persist: True

/etc/sysctl.d/10-k8s-cri.conf:
  file.managed:
    - contents: net.ipv4.ip_forward = 1

apply_sysctl_change_for_cri:
  cmd.run:
    - name: sysctl --system
    - onchanges:
      - file: /etc/sysctl.d/10-k8s-cri.conf

#   -------------------------------------------------------------
#   Repository
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

libcontainers_repo:
  pkgrepo.managed:
    - humanname: libcontainers
    - name: deb https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/{{ k8s['os'] }} /
    - file: /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list
    - dist: /
    - key_url: salt://roles/paas-kubernetes/kubernetes/files/libcontainers-apt-key.gpg

cri-o_repo:
  pkgrepo.managed:
    - humanname: CRI-O
    - name: deb http://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable:/cri-o:/{{ k8s['version'] }}/{{ k8s['os'] }} /
    - file: /etc/apt/sources.list.d/devel:kubic:libcontainers:stable:cri-o:{{ k8s['version'] }}.list
    - dist: /
    - key_url: salt://roles/paas-kubernetes/kubernetes/files/cri-o-apt-key.gpg

#   -------------------------------------------------------------
#   CRI-O packages
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

libseccomp2:
  pkg.latest:
    - fromrepo: {{ grains['oscodename'] }}-backports

cri-o_packages:
  pkg.installed:
    - pkgs:
      - cri-o
      - cri-o-runc
    - hold: True

/etc/crio/crio.conf.d:
  file.recurse:
    - source: salt://roles/paas-kubernetes/kubernetes/files/crio.conf.d
    - include_empty: True

#   -------------------------------------------------------------
#   Service
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

cri-o_service:
  service.running:
    - name: crio
    - enable: True
    - onchanges:
      - pkg: cri-o_packages
