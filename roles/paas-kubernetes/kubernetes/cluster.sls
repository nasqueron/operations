#   -------------------------------------------------------------
#   Salt — Kubernetes
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

#   -------------------------------------------------------------
#   Provide kubeadm configuration
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/path/to/kubeadm/config:
  file.managed:
    - source: salt://salt://roles/paas-kubernetes/kubernetes/files/kubeadm.yaml
