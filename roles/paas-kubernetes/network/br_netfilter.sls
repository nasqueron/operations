#   -------------------------------------------------------------
#   Salt — Kubernetes
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#   Project:        Nasqueron
#   Created:        2020-09-20
#   License:        Trivial work, not eligible to copyright
#   -------------------------------------------------------------

#   -------------------------------------------------------------
#   Let iptables see bridged traffic
#   - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

br_netfilter:
  kmod.present:
    - persist: True

/etc/sysctl.d/10-k8s-br_netfilter.conf:
  file.managed:
    - contents: |
        net.bridge.bridge-nf-call-ip6tables = 1
        net.bridge.bridge-nf-call-iptables = 1

apply_sysctl_change_for_br_netfilter:
  cmd.run:
    - name: sysctl --system
    - onchanges:
      - file: /etc/sysctl.d/10-k8s-br_netfilter.conf
