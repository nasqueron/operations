#   -------------------------------------------------------------
#   Salt — Kubernetes
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2020-09-20
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

#   -------------------------------------------------------------
#   Repository
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

kubernetes_repo:
  pkgrepo.managed:
    - humanname: Kubernetes
    - name: deb https://apt.kubernetes.io/ kubernetes-xenial main
    - dist: kubernetes-xenial
    - file: /etc/apt/sources.list.d/kubernetes.list
    - key_url: salt://roles/paas-kubernetes/kubernetes/files/kubernetes-apt-key.gpg

#   -------------------------------------------------------------
#   Kubernetes packages
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

kubernetes_packages:
  pkg.installed:
    - pkgs:
      - kubelet
      - kubeadm
      - kubectl
    - hold: True
